# Simple DevOps Tools Installation Guide (Jenkins, Maven, Docker, Trivy on AWS Ubuntu)

This friendly, step-by-step guide helps you install all the tools needed for your DevOps CI/CD pipeline on an AWS EC2 Ubuntu server. Each section explains what the tool does and gives you plain commands to copy-paste directly into your server terminal.

> 💡 **Tip for Beginners:** Before starting, log into your EC2 Ubuntu instance via SSH using your terminal or Git Bash. Run the installation commands one by one to make sure everything sets up perfectly.

---

### Step 1: System Update & OpenJDK 17
**What it does:** Refreshes your server's package library and installs Java 17. Jenkins is built on Java, so it cannot run without this step.

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install openjdk-17-jdk -y
java -version
```

---

### Step 2: Install Jenkins
**What it does:** Adds the official secure Jenkins software repository to your server and installs the Jenkins automation engine itself.

```bash
# Add Jenkins repository key for secure download
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add the Jenkins package channel to your system repositories
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update application registry and install Jenkins
sudo apt update
sudo apt install jenkins -y

# Start Jenkins and make sure it auto-starts when the server reboots
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins
```

---

### Step 3: Install Apache Maven
**What it does:** Installs the compilation tool. Maven will take your Java source code, test it, and bundle it neatly into an executable '.war' file package as defined in your Jenkinsfile pipeline.

```bash
sudo apt install maven -y
mvn -version
```

---

### Step 4: Install Docker Engine & Fix Permissions
**What it does:** Installs the container builder. Crucially, it links Jenkins and Docker together so that your pipeline runs can build custom application images without triggering 'Permission Denied' security errors.

```bash
# Install core container engine packages
sudo apt install docker.io -y

# Start the engine and ensure boot auto-start
sudo systemctl start docker
sudo systemctl enable docker

# Crucial Step: Add 'jenkins' user to the administrative 'docker' security group
sudo usermod -aG docker jenkins

# Apply permissions changes instantly without needing a full system reboot
sudo chmod 666 /var/run/docker.sock
sudo systemctl restart jenkins
```

---

### Step 5: Install Trivy Security Scanner
**What it does:** Downloads Aqua Security's vulnerability scanner. It scans built container layers for dangerous software bugs before pushing images to your cloud registry. We also set up the custom storage folders your script uses.

```bash
# Install dependency tools to handle secure server keys
sudo apt install wget apt-transport-https gnupg lsb-release -y

# Securely download and install official Trivy package signatures
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list

# Update indices and install Trivy
sudo apt update
sudo apt install trivy -y

# Build the specialized work folders mentioned in your Jenkinsfile
sudo mkdir -p /var/lib/jenkins/trivy-tmp
sudo mkdir -p /var/lib/jenkins/.cache/trivy
sudo chown -R jenkins:jenkins /var/lib/jenkins/trivy-tmp
sudo chown -R jenkins:jenkins /var/lib/jenkins/.cache/trivy
```

---

### Step 6: Access Your Jenkins Setup Interface
**What it does:** Guides you through grabbing your master administration key to unlock the browser tool window and begin configuration setups.

* **AWS Firewall Setup:** Ensure you open port 8080 in your AWS EC2 Security Group rules so your computer can reach the control dashboard online.
* **Open Web Portal:** Open your favorite internet browser window and navigate to: `http://<your-ec2-public-ip>:8080`.
* **Grab Admin Unlock Key:** Copy and paste this terminal shell check command to see your default browser access password print out on screen:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Simply paste that long text sequence into your browser setup dialog prompt, pick 'Install Suggested Plugins', and you are fully ready to configure your pipeline pipeline script integrations!
