require 'sinatra'
require 'json'
require 'net/http'
require 'uri'

OLLAMA_HOST = ENV['OLLAMA_HOST'] || 'http://localhost:11434'

STYLE = '<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: system-ui, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; background: #1a1a2e; color: #eee; }
  h1 { margin-bottom: 10px; }
  pre { background: #16213e; padding: 15px; border-radius: 8px; overflow-x: auto; border: 1px solid #333; margin: 10px 0; }
  form { margin: 15px 0; display: flex; gap: 10px; flex-wrap: wrap; align-items: center; }
  label { font-size: 14px; }
  input[type="text"] { padding: 10px; border-radius: 8px; border: 1px solid #333; background: #16213e; color: #eee; font-size: 14px; flex: 1; min-width: 200px; }
  input[type="submit"], .btn { padding: 10px 20px; border-radius: 8px; border: none; background: #e94560; color: white; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; }
  input[type="submit"]:hover, .btn:hover { background: #c73650; }
  .nav { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 20px; }
  p { margin: 10px 0; }
</style>'

# === Route for df.rb ===
get '/df' do
  content_type :html
  <<-HTML
    <!DOCTYPE html>
    <html>
    <head><title>OllaOS - df</title>#{STYLE}</head>
    <body>
      <h1>System Disk Usage</h1>
      <pre>#{`df -h`}</pre>
      <a href="/" class="btn">Back</a>
    </body>
    </html>
  HTML
end

# === Route for fastfetch.rb ===
get '/fastfetch' do
  content_type :html
  <<-HTML
    <!DOCTYPE html>
    <html>
    <head><title>OllaOS - fastfetch</title>#{STYLE}</head>
    <body>
      <h1>System Info</h1>
      <pre>#{`fastfetch`}</pre>
      <a href="/" class="btn">Back</a>
    </body>
    </html>
  HTML
end

# === Route for ol_pull.rb ===
get '/ol_pull' do
  model_name = params['model']
  content_type :html
  if model_name
    result = `ollama pull #{model_name} 2>&1`
    <<-HTML
      <!DOCTYPE html>
      <html>
      <head><title>OllaOS - Pull Model</title>#{STYLE}</head>
      <body>
        <h1>Model Downloaded</h1>
        <pre>#{result}</pre>
        <a href="/" class="btn">Back</a>
      </body>
      </html>
    HTML
  else
    <<-HTML
      <!DOCTYPE html>
      <html>
      <head><title>OllaOS - Pull Model</title>#{STYLE}</head>
      <body>
        <h1>Pull Ollama Model</h1>
        <form method="get" action="/ol_pull">
          <label>Model name: <input type="text" name="model" /></label>
          <input type="submit" value="Pull" />
        </form>
      </body>
      </html>
    HTML
  end
end

# === Chat interface ===
get '/ol_run' do
  uri = URI("#{OLLAMA_HOST}/api/tags")
  models = JSON.parse(Net::HTTP.get(uri))['models'].map { |m| m['name'] } rescue []

  content_type :html
  <<-HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>OllaOS Chat</title>
      <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: system-ui, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; background: #1a1a2e; color: #eee; }
        h1 { margin-bottom: 10px; }
        .bar { display: flex; gap: 8px; align-items: center; margin: 10px 0; }
        select { padding: 6px 10px; border-radius: 4px; border: 1px solid #333; background: #16213e; color: #eee; flex: 1; }
        #chat { height: 50vh; overflow-y: auto; border: 1px solid #333; padding: 10px; border-radius: 8px; background: #16213e; display: flex; flex-direction: column; gap: 8px; }
        .msg { padding: 10px 14px; border-radius: 12px; max-width: 85%; line-height: 1.5; white-space: pre-wrap; word-wrap: break-word; }
        .user { background: #0f3460; align-self: flex-end; }
        .assistant { background: #1a1a40; align-self: flex-start; }
        .form { display: flex; gap: 8px; margin-top: 10px; }
        #message { flex: 1; padding: 10px; border-radius: 8px; border: 1px solid #333; background: #16213e; color: #eee; font-size: 14px; }
        button, .btn { padding: 10px 20px; border-radius: 8px; border: none; background: #e94560; color: white; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; }
        button:hover, .btn:hover { background: #c73650; }
        .loading { text-align: center; padding: 10px; color: #888; }
        .nav { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 20px; }
      </style>
    </head>
    <body>
      <h1>OllaOS Chat</h1>
      <a href="/" class="btn">Back</a>
      <div class="bar">
        <label>Model:</label>
        <select id="model">
          #{models.empty? ? '<option>No models found</option>' : models.map { |m| "<option>#{m}</option>" }.join("\n          ")}
        </select>
      </div>
      <div id="chat"></div>
      <div class="form">
        <input type="text" id="message" placeholder="Type your message..." autofocus />
        <button onclick="send()">Send</button>
      </div>
      <script>
        const chat = document.getElementById('chat');
        const model = document.getElementById('model');
        const input = document.getElementById('message');
        const messages = [];

        function addMsg(role, content) {
          const div = document.createElement('div');
          div.className = 'msg ' + role;
          div.textContent = content;
          chat.appendChild(div);
          chat.scrollTop = chat.scrollHeight;
        }

        async function send() {
          const text = input.value.trim();
          if (!text) return;
          input.value = '';
          messages.push({ role: 'user', content: text });
          addMsg('user', text);

          const load = document.createElement('div');
          load.className = 'loading';
          load.textContent = 'Thinking...';
          chat.appendChild(load);

          try {
            const res = await fetch('/api/chat', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ model: model.value, messages: messages })
            });
            const data = await res.json();
            const reply = data.message?.content || 'Error: ' + (data.error || 'No response');
            messages.push({ role: 'assistant', content: reply });
            load.remove();
            addMsg('assistant', reply);
          } catch(e) {
            load.remove();
            addMsg('assistant', 'Connection error: ' + e.message);
          }
        }

        input.addEventListener('keydown', function(e) {
          if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); send(); }
        });
      </script>
    </body>
    </html>
  HTML
end

post '/api/chat' do
  content_type :json
  body = JSON.parse(request.body.read)

  uri = URI("#{OLLAMA_HOST}/api/chat")
  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Post.new(uri)
  req['Content-Type'] = 'application/json'
  req.body = { model: body['model'], messages: body['messages'], stream: false }.to_json

  res = http.request(req)
  res.body
end

# === Route for ls.rb ===
get '/ls' do
  content_type :html
  <<-HTML
    <!DOCTYPE html>
    <html>
    <head><title>OllaOS - ls</title>#{STYLE}</head>
    <body>
      <h1>Directory Content</h1>
      <pre>#{`ls -la`}</pre>
      <a href="/" class="btn">Back</a>
    </body>
    </html>
  HTML
end

# === Route for pwd.rb ===
get '/pwd' do
  content_type :html
  <<-HTML
    <!DOCTYPE html>
    <html>
    <head><title>OllaOS - pwd</title>#{STYLE}</head>
    <body>
      <h1>Current Directory</h1>
      <pre>#{`pwd`}</pre>
      <a href="/" class="btn">Back</a>
    </body>
    </html>
  HTML
end

# === Route for top.rb ===
get '/top' do
  content_type :html
  <<-HTML
    <!DOCTYPE html>
    <html>
    <head><title>OllaOS - top</title>#{STYLE}</head>
    <body>
      <h1>System Processes</h1>
      <pre>#{`top -bn1`}</pre>
      <a href="/" class="btn">Back</a>
    </body>
    </html>
  HTML
end

# === Route for ol_list.rb ===
get '/ol_list' do
  content_type :html
  <<-HTML
    <!DOCTYPE html>
    <html>
    <head><title>OllaOS - Models</title>#{STYLE}</head>
    <body>
      <h1>Ollama Models</h1>
      <pre>#{`ollama list`}</pre>
      <a href="/" class="btn">Back</a>
    </body>
    </html>
  HTML
end

# === Route for geany.rb ===
get '/geany' do
  system('geany &')
  content_type :html
  <<-HTML
    <!DOCTYPE html>
    <html>
    <head><title>OllaOS - Geany</title>#{STYLE}</head>
    <body>
      <h1>Geany Editor</h1>
      <p>Geany has been launched.</p>
      <a href="/" class="btn">Back</a>
    </body>
    </html>
  HTML
end

# === Route for up_deb.rb ===
get '/up_deb' do
  content_type :html
  <<-HTML
    <!DOCTYPE html>
    <html>
    <head><title>OllaOS - Update</title>#{STYLE}</head>
    <body>
      <h1>System Update</h1>
      <pre>#{`sudo apt update && sudo apt upgrade -y 2>&1`}</pre>
      <a href="/" class="btn">Back</a>
    </body>
    </html>
  HTML
end

# === Route for web_search.rb ===
get '/web_search' do
  query = params['q']
  content_type :html
  if query
    result = `ddgr --np "#{query}" 2>&1`
    <<-HTML
      <!DOCTYPE html>
      <html>
      <head><title>OllaOS - Search</title>#{STYLE}</head>
      <body>
        <h1>Search Results: #{query}</h1>
        <pre>#{result}</pre>
        <a href="/web_search" class="btn">New Search</a>
        <a href="/" class="btn">Back</a>
      </body>
      </html>
    HTML
  else
    <<-HTML
      <!DOCTYPE html>
      <html>
      <head><title>OllaOS - Search</title>#{STYLE}</head>
      <body>
        <h1>Web Search</h1>
        <form method="get" action="/web_search">
          <label>Search for: <input type="text" name="q" /></label>
          <input type="submit" value="Search" />
        </form>
      </body>
      </html>
    HTML
  end
end

# === Route for wget.rb ===
get '/wget' do
  url = params['url']
  content_type :html
  if url
    result = `wget "#{url}" 2>&1`
    <<-HTML
      <!DOCTYPE html>
      <html>
      <head><title>OllaOS - Download</title>#{STYLE}</head>
      <body>
        <h1>Download Complete</h1>
        <pre>#{result}</pre>
        <a href="/wget" class="btn">New Download</a>
        <a href="/" class="btn">Back</a>
      </body>
      </html>
    HTML
  else
    <<-HTML
      <!DOCTYPE html>
      <html>
      <head><title>OllaOS - Download</title>#{STYLE}</head>
      <body>
        <h1>Download File</h1>
        <form method="get" action="/wget">
          <label>Download link: <input type="text" name="url" size="50" /></label>
          <input type="submit" value="Download" />
        </form>
      </body>
      </html>
    HTML
  end
end

# === Default route (index) ===
get '/' do
  content_type :html
  <<-HTML
    <!DOCTYPE html>
    <html>
    <head><title>OllaOS</title>#{STYLE}</head>
    <body>
      <h1>Welcome to OllaOS (Web Interface)</h1>
      <p>Select an action:</p>
      <div class="nav">
        <a href="/ls" class="btn">ls (List Files)</a>
        <a href="/pwd" class="btn">pwd (Current Dir)</a>
        <a href="/df" class="btn">df (Disk Usage)</a>
        <a href="/top" class="btn">top (Processes)</a>
        <a href="/fastfetch" class="btn">fastfetch (System Info)</a>
        <a href="/ol_list" class="btn">Ollama Models</a>
        <a href="/ol_pull" class="btn">Pull Ollama Model</a>
        <a href="/ol_run" class="btn">Chat with Ollama</a>
        <a href="/web_search" class="btn">Web Search</a>
        <a href="/wget" class="btn">Download File</a>
        <a href="/geany" class="btn">Launch Geany</a>
        <a href="/up_deb" class="btn">System Update</a>
      </div>
    </body>
    </html>
  HTML
end

