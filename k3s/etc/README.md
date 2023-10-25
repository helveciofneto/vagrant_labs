# Custom Vagrant/Ruby Files
You can add `.rb` files in each lab's `./etc/` directory to run additional commands that may be specific to your local system. Some use cases include:
- Create a folder sync to a path that only exists in your computer;
- Run a shared or custom Shell script or executable file;
- Declare Environment Variables/Secrets to be consumed by your VMs without exposing them as code to other users.

The following is a sample file that can be saved as `./etc/example.rb`:
```ruby
# Include secrets from a file called "secrets.rb":
require_relative "secrets.rb"
include Secrets

Vagrant.configure("2") do |config|
  # Sync local directory:
  config.vm.synced_folder "D:/K8s", "/home/vagrant/localdir", type: "virtualbox"

  # Run a shared script:
  config.vm.provision "shell", path: "../shared/aws_cli.sh"

  # Run a custom script with the included secrets:
  config.vm.provision "shell",
    path: "./etc/custom_script.sh",
    env: {"USERNAME" => Secrets::USERNAME,
          "PASSWORD" => Secrets::PASSWORD}
end
```
