###------------------------------ ad azfw ------------------------------###
/*
#---------- AVS part ----------# 
resource "azurerm_availability_set" "ad-vm-avs" {
  name                = "jhyoon-ad-vm-avs"
  resource_group_name = azurerm_resource_group.azfw-rg.name
  location = azurerm_resource_group.azfw-rg.location
  managed = true
  platform_fault_domain_count = 2
  platform_update_domain_count = 2
}
*/

#---------- Public IP part ----------# 
resource "azurerm_public_ip" "ad-vm-pip" {
  name = "jhyoon-ad-pip"
  resource_group_name = azurerm_resource_group.azfw-rg.name
  location = azurerm_resource_group.azfw-rg.location
  allocation_method = "Static"
}

#---------- NIC part ----------#
resource "azurerm_network_interface" "ad-vm-nic" {
  name                = "jhyoon-ad-nic"
  resource_group_name = azurerm_resource_group.azfw-rg.name
  location = azurerm_resource_group.azfw-rg.location

  ip_configuration {
    name                = "jhyoon-ad-nic-ipconfig"
    subnet_id                     = azurerm_subnet.ad-snet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.ad-vm-pip.id
  }
}

#---------- NSG Mapping ----------#
resource "azurerm_network_interface_security_group_association" "ad-vm-nsg" {
  network_interface_id = azurerm_network_interface.ad-vm-nic.id
  network_security_group_id = azurerm_network_security_group.ad-vm-nsg.id
}

#---------- VM part ----------#
resource "azurerm_virtual_machine" "ad-vm" {
  name                  = "jhyoon-ad-vm"
  resource_group_name = azurerm_resource_group.azfw-rg.name
  location = azurerm_resource_group.azfw-rg.location
  network_interface_ids = [azurerm_network_interface.ad-vm-nic.id]
 # availability_set_id = azurerm_availability_set.ad-vm-avs.id
  vm_size               = "Standard_B2ms"
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "jhyoon-ad-vm-osdisk"
    caching           = "ReadWrite"
    create_option     = "fromimage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_2"
    version   = "latest"
  }

  os_profile {
    computer_name  = "jhyoon-ad-vm"
    admin_username = "jhyoon"
    admin_password = "P@ssw@rd!@#"
  }

  os_profile_linux_config {
    disable_password_authentication = false

  }
/*
  storage_data_disk {
    name              = "jhyoon-ad-vm-datadisk"
    lun = 0
    caching           = "ReadWrite"
    create_option     = "empty"
    managed_disk_type = "Premium_LRS"
    disk_size_gb = 128
  }
  */
}

#---------- NSG ----------#
resource "azurerm_network_security_group" "ad-vm-nsg" {
  name                = "jhyoon-ad-nsg"
  resource_group_name = azurerm_resource_group.azfw-rg.name
  location = azurerm_resource_group.azfw-rg.location
}

#---------- NSG rule ----------#
resource "azurerm_network_security_rule" "ad-vm-nsg-4000" {
  resource_group_name = azurerm_resource_group.azfw-rg.name
  network_security_group_name = azurerm_network_security_group.ad-vm-nsg.name
  name                       = "zenith-office-jhyoon-4000"
  priority                   = 4000
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefixes      = ["123.141.145.65"]
  destination_address_prefix = "*"
  description = "123.141.145.65 - Zenith office"
}

/*
###------------------------------ svr-vm azfw ------------------------------###
#---------- AVS part ----------# 
resource "azurerm_availability_set" "svr-vm-avs" {
  name                = "jhyoon-svr-vm-avs"
  resource_group_name = azurerm_resource_group.azfw-rg.name
  location = azurerm_resource_group.azfw-rg.location
  managed = true
  platform_fault_domain_count = 2
  platform_update_domain_count = 2
}

#---------- Public IP part ----------# 
resource "azurerm_public_ip" "svr-vm-pip" {
  name = "jhyoon-svr-vm-pip"
  resource_group_name = azurerm_resource_group.azfw-rg.name
  location = azurerm_resource_group.azfw-rg.location
  allocation_method = "Static"
}

#---------- NIC part ----------#
resource "azurerm_network_interface" "svr-vm-nic" {
  name                = "jhyoon-svr-vm-nic"
  resource_group_name = azurerm_resource_group.azfw-rg.name
  location = azurerm_resource_group.azfw-rg.location

  ip_configuration {
    name                = "jhyoon-svr-vm-nic-ipconfig"
    subnet_id                     = azurerm_subnet.svr-snet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.svr-vm-pip.id
  }
}

#---------- NSG Mapping ----------#
resource "azurerm_network_interface_security_group_association" "svr-vm-nsg" {
  network_interface_id = azurerm_network_interface.svr-vm-nic.id
  network_security_group_id = azurerm_network_security_group.svr-vm-nsg.id
}

#---------- VM part ----------#
resource "azurerm_virtual_machine" "svr-vm" {
  name                  = "jhyoon-svr-vm-VM"
  resource_group_name = azurerm_resource_group.azfw-rg.name
  location = azurerm_resource_group.azfw-rg.location
  network_interface_ids = [azurerm_network_interface.svr-vm-nic.id]
  availability_set_id = azurerm_availability_set.svr-vm-avs.id
  vm_size               = "Standard_B2ms"
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "jhyoon-svr-vm-osdisk"
    caching           = "ReadWrite"
    create_option     = "fromimage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_profile {
    computer_name  = "jhyoon-ws-vm"
    admin_username = "user"
    admin_password = "passwordinput"
  }

  os_profile_windows_config {

  }

  storage_data_disk {
    name              = "jhyoon-svr-vm-datadisk"
    lun = 0
    caching           = "ReadWrite"
    create_option     = "empty"
    managed_disk_type = "Premium_LRS"
    disk_size_gb = 128
  }
}

#---------- NSG ----------#
resource "azurerm_network_security_group" "svr-vm-nsg" {
  name                = "jhyoon-svr-vm-nsg"
  resource_group_name = azurerm_resource_group.azfw-rg.name
  location = azurerm_resource_group.azfw-rg.location
}

#---------- NSG rule ----------#
resource "azurerm_network_security_rule" "svr-vm-nsg-4000" {
  resource_group_name = azurerm_resource_group.azfw-rg.name
  network_security_group_name = azurerm_network_security_group.svr-vm-nsg.name
  name                       = "zenith-office-jhyoon-4000"
  priority                   = 4000
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefixes      = ["123.141.145.65"]
  destination_address_prefix = "*"
  description = "123.141.145.65 - Zenith office"
}
*/