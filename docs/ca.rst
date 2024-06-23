Certificate Authority (CA)
===================

Installation and Configuration Guide
-----------------

We will begin configuring our CA. It's a lengthy process, one that we must do to save some money at the cost of a tiresome and boring process. So you might ask, "Is it really worth it"? To answer this question, you must follow the steps below:

---------------------

CA Setup - Installing
~~~~~~~~~~~~~~~~

This is what you need to install in order to make and sign your CAs. You can use the same VM you're using to your DNS Server.

Install Easy-RSA
^^^^^^^^^^^^^^^^

.. code-block:: console

   sudo apt-get install easy-rsa -y

We start by installing Easy-RSA, which is a command-line utility that simplifies the process of setting up and managing Public Key Infrastructure (PKI) and creating certificates.

Install Lighttpd
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo apt-get install lighttpd -y

We then install Lighttpd, which is a lightweight web server. It's ideal for serving static content, and we will be using it later to easily download our CA.

---------------------

CA Setup - Configuring
~~~~~~~~~~~~~~~~

We will now proceed to configure our CA VM.

Copy Easy-RSA to the current directory
^^^^^^^^^^^^^^^^

.. code-block:: console

    cp -R /usr/share/easy-rsa/ .
    cd easy-rsa

Copy the Easy-RSA scripts to the current directory for customization then navigate to the Easy-RSA directory

Rename the vars example file
^^^^^^^^^^^^^^^^

.. code-block:: console

    mv vars.example vars

Rename the vars.example file to vars. This file contains the configuration settings for Easy-RSA.

Edit the vars file
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo nano vars

Open the vars file with nano to configure Easy-RSA settings. You can replace the content with the following:

.. code-block:: console
    
    if [ -z "$EASYRSA_CALLER" ]; then
    echo "You appear to be sourcing an Easy-RSA _vars_ file. This is" >&2
    echo "no longer necessary and is disallowed. See the section called" >&2
    echo "_How to use this file_ near the top comments for more details." >&2
    return 1
    fi

    set_var EASYRSA_DN "org"

    set_var EASYRSA_REQ_COUNTRY "CA"
    set_var EASYRSA_REQ_PROVINCE "Nova Scotia"
    set_var EASYRSA_REQ_CITY "Truro"
    set_var EASYRSA_REQ_ORG "Safehouse CA"
    set_var EASYRSA_REQ_EMAIL "me@safehouse.net"
    set_var EASYRSA_REQ_OU "Safehouse CA"

.. note::

   The content here is not crucial, you can fill the information with whatever you want, but this information is needed for our CA.

Initialize the Public Key Infrastructure (PKI)
^^^^^^^^^^^^^^^^

.. code-block:: console

    ./easyrsa init-pki

Initialize the PKI directory where certificates and keys will be stored.

Build the Certificate Authority (CA)
^^^^^^^^^^^^^^^^

Generate the root certificate for the CA. You will be prompted to set and confirm a password for the CA. Make sure to remember this password.
You will be asked for several pieces of information during this process. For most of them, you can simply press `Enter`` to accept the default value. However, when prompted for `"Common Name"`, make sure to enter "safehouse.com."

.. code-block:: console

    ./easyrsa build-ca

Copy the CA certificate to the web server directory
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo cp pki/ca.crt /var/www/html

Copy the generated CA certificate to the Lighttpd web server's document root.

Set the correct permissions for the CA certificate
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo chmod +r /var/www/html/ca.crt

This will ensure the CA certificate file is readable by the web server.

Start the Lighttpd web server
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo systemctl start lighttpd

Start the Lighttpd service to serve the CA certificate.

---------------------

And you're all set! At least for now. We're not done using the terminal in the DNS/CA VM, so leave it open. We will come back to it at a later moment.
For now, you should be able to download your certificate by visiting `ca.safehouse.com`, so do it.

As we can't yet proceed, we will move on to install and configure the GitLab VM.