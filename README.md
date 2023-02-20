# terraform_azure_pihole
Creating a Pi-hole in Azure using Terraform
https://www.gerjon.com/run-a-pihole-securely-in-azure/



Next step is to create a VNet that can be used to connect the Azure Container instance to and act as a LAN connection for the firewall. So first up establish the subscription and the correct resource group (the one you created earlier). Be sure to select the same region for all parts of the deployment.


After clicking next you are asked to fill in the IP address space and the subnets. the default subnet name is default, i changed it to Pi-hole to keep track of the primary use of the subnet.


After clicking next we are asked if we want to deploy the firewall.. Yes please :-). For an Azure Firewall to be functional you must have an AzureGatewaySubnet subnet available inside the VNet. This is necessary for Azure to host the Virtual Machine(s) that make up the Azure Firewall. to these are put in the Firewall subnet address space. In my case i also created a new WAN ip address (static) that will be used by the firewall for WAN connection.



After clicking next and finish the VNet and Azure Firewall are being set up. Wait for this to finish and then go to the Azure Container environment in Azure. Click create to create a new Azure Container Instance

First select the correct subscription and resource group. Chose a name for the container instance. For image source chose Docker Hub or other registry, because we are going to use a Docker image for this container and choose the public image type because we are using the public Docker image registry.


Scroll down to fill in the rest of the property’s. For image type in pihole/pihole:latest, this will download the latest version of the docker container and install it. Click also on the change size button to downsize the default Docker image resources. Pi-hole should run on 500 MB memory and 1 CPU but I choose 1 GB to keep enough memory for smooth operation of the instance.


In the next step you need to add the virtual network to which the Pihole will connect (the one you created earlier) and also what ports should be available to connect to from outside the Container Instance. The ports (53,67,80 and 443) are retrieved from the official Pi-hole documentation (https://docs.pi-hole.net/main/prerequisites/).


Click next, next and finish to complete the deployment of the Container Instance. Azure will now download the latest Pi-hole docker image from the registry and spin it up. It will connect it to the VNet and will configure to ports to be available inside the VNet. Next step is to create the necessary DNAT rules on the Azure Firewall to allow my WAN IP address access to the Pihole instance (and not make it publicly available for everyone).

Navigate to the virtual networks segment of the Azure portal. choose the Pi-hole VNet and choose the created firewall.


After clicking on piholefirewall you are redirected to the firewall instance. Choose the firewall manager and click on the Azure Firewall manager button.

Chose the Azure Firewall policies to configure the required DNAT rules.


Next step is to create a new firewall policy


First step is to configure the correct subscription and resource group for the ruleset. Choose the policy tier standard to keep the cost low :-).


Click next and next again until you get to the Rules tab.


Next step is to add the rule collection. Make sure you choose the DNAT option so the firewall will route traffic from the WAN interface to the LAN interface of the Docker instance.


Next step is to add the rules. these are outlined below. you need to fill in the rules as they are nesscesary for you environment.

Name	Source Type	Source	Protocol	Destination ports	Destination type	Destination	Translated Address	Translated port
DNS1	IP address	WAN IP of your home environment	UDP	53	IP address	WAN IP address of Azure Firewall	Internal Ip address of the docker Instance	53
DNS2	IP address	WAN IP of your home environment	UDP	67	IP address	WAN IP address of Azure Firewall	Internal Ip address of the docker Instance	67
mgt1	IP address	WAN IP of your home environment	TCP	80	IP address	WAN IP address of Azure Firewall	Internal Ip address of the docker Instance	80
mgt2	IP address	WAN IP of your home environment	TCP	443	IP address	WAN IP address of Azure Firewall	Internal Ip address of the docker Instance	443
This gives the following ruleset in my case


After you click add, click on review and create. This will create the firewall rules. Next up test if you can connect to the WAN ip address of the Azure firewall on port 80 to see if you can log on to the Pi-hole. You will be greeted with a login page requesting for a password. This password is created on the deployment of the Docker image. You can retrieve that password by navigating to the Container Instance part of the Azure Portal and choose the Pi-hole instance created earlier.


After you clicked on Pihole, choose containers select Pi-hole and open Logs if you scroll down a bit you will see the log entry defining the password. You can use this to log on.


Test if you can connect to the WAN ip of the Azure Firewall via your Phone via another IP address to see if IP restrictions are set up correctly.

Next step will be to change your internal DHCP servers to serve the WAN ip address of the Azure Firewall as primary DNS. After a while you will see incoming DNS requests and you can keep your environment a bit more safe. If you need to add more Ip addresses to the allow list in the Azure Firewall you can do as you wish. I would advise only to allow extra connections to port 53 and 67 for DNS queries and keep the management interface only bound to your WAN IP to keep the management portal as safe as possible.

Hope this helps someone.

Leave a Reply
You must be logged in to post a comment.

Powered by Esotera & WordPress.©2023 Gerjon.com
Back to Top