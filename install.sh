# Create necessary directories
sudo install -o0 -g0 -m755 -d /usr/local/bin
sudo install -o0 -g0 -m755 -d /usr/local/lib/ollama

# Extract the Ollama bundle to the right location
sudo tar -xzf ollama-linux-amd64.tgz -C /usr/local

# Create a symbolic link to make the 'ollama' command available
sudo ln -sf /usr/local/ollama /usr/local/bin/ollama

# Create the dedicated 'ollama' user and group
sudo useradd -r -s /bin/false -U -m -d /usr/share/ollama ollama

# Add your current user to the 'ollama' group to run commands without sudo
sudo usermod -a -G ollama $(whoami)

# Create the systemd service file
sudo tee /etc/systemd/system/ollama.service > /dev/null <<'EOF'
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=/usr/local/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3
Environment="PATH=/usr/local/bin:/usr/bin:/bin"

[Install]
WantedBy=default.target
EOF

# Reload systemd, enable, and start the service
sudo systemctl daemon-reload
sudo systemctl enable ollama.service
sudo systemctl start ollama.service