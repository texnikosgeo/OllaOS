require 'sinatra'
require 'json'

# This will run your existing Ruby scripts
# You can move the entire OllaOS folder into this app folder and use it like a framework

# === Route for df.rb ===
get '/df' do
  # Run the df script and return output as HTML
  system('df -h')
  content_type :html
  <<-HTML
    <h1>System Disk Usage</h1>
    <pre>#{`df -h`}</pre>
    <p>Press Enter to continue...</p>
    <input type="text" placeholder="Press Enter" id="continue" />
    <script>
      document.getElementById('continue').addEventListener('keydown', function(e) {
        if (e.key === 'Enter') window.location.reload();
      });
    </script>
  HTML
end

# === Route for fastfetch.rb ===
get '/fastfetch' do
  system('fastfetch')
  content_type :html
  <<-HTML
    <h1>System Info</h1>
    <pre>#{`fastfetch`}</pre>
    <p>Press Enter to continue...</p>
    <input type="text" placeholder="Press Enter" id="continue" />
    <script>
      document.getElementById('continue').addEventListener('keydown', function(e) {
        if (e.key === 'Enter') window.location.reload();
      });
    </script>
  HTML
end

# === Route for ol_pull.rb ===
get '/ol_pull' do
  puts "Please type the model name:"
  print "> "
  model_name = gets.chomp
  puts `ollama pull #{model_name}`
  content_type :html
  <<-HTML
    <h1>Model Downloaded</h1>
    <pre>#{`ollama pull #{model_name}`}</pre>
    <p>Press Enter to continue...</p>
    <input type="text" placeholder="Press Enter" id="continue" />
    <script>
      document.getElementById('continue').addEventListener('keydown', function(e) {
        if (e.key === 'Enter') window.location.reload();
      });
    </script>
  HTML
end

# === Route for ol_run.rb ===
get '/ol_run' do
  puts "Please type the model name:"
  print "> "
  model_name = gets.chomp
  puts `ollama run #{model_name}`
  content_type :html
  <<-HTML
    <h1>Running Model: #{model_name}</h1>
    <pre>#{`ollama run #{model_name}`}</pre>
    <p>Press Enter to continue...</p>
    <input type="text" placeholder="Press Enter" id="continue" />
    <script>
      document.getElementById('continue').addEventListener('keydown', function(e) {
        if (e.key === 'Enter') window.location.reload();
      });
    </script>
  HTML
end

# === Default route (index) ===
get '/' do
  <<-HTML
    <h1>Welcome to OllaOS (Web Interface)</h1>
    <p>Click one of the buttons below to run a local command:</p>
    <ul>
      <li><a href="/df">df (Disk Usage)</a></li>
      <li><a href="/fastfetch">fastfetch (System Info)</a></li>
      <li><a href="/ol_pull">Pull Ollama Model</a></li>
      <li><a href="/ol_run">Run Ollama Model</a></li>
    </ul>
  HTML
end

