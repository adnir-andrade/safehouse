GitLab
===================

Installation and Configuration Guide
-----------------

If you made up to this point, there is little to fear. The worst that can happen is for your computer to run out of RAM and corrupt everything you have done so far. But apart from that, we will be mostly following the standard installation of GitLab. There are two moments where you need to pay attention, but don't worry, they will be highlighted.
For now, let's start by creating another (and more robust) VM on Multipass and start installing what we need to make our local GitLab server work before we run out of memory.

---------------------

GitLab Setup - Installing
~~~~~~~~~~~~~~~~

This is what you need to install before we can actually dive into GitLab.

Update the Package List
^^^^^^^^^^^^^^^^

.. code-block:: console

   sudo apt-get update

We can start by updating the list of available packages and their versions

Install Easy-RSA
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo apt-get install easy-rsa -y

We will need Easy-RSA in this VM as well, so let's install it.

Install GitLab dependencies
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

Install necessary dependencies for GitLab, including curl, OpenSSH server, CA certificates, timezone data, and Perl.

Add the GitLab package repository and install the package
^^^^^^^^^^^^^^^^

.. code-block:: console

    curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash

Does exactly what it says.

---------------------

Intermission - CA Setup (GitLab VM)
~~~~~~~~~~~~~~~~

Remember when the author mentioned that the CA session would be lengthy? That's because it can only end here at this point. 
Before we can proceed any further, we need to properly set up, configure, and sign our CA. As described in the "Install self-managed GitLab" session of the Gitlab website:
>For https:// URLs, GitLab will automatically request a certificate with Let's Encrypt, which requires inbound HTTP access and a valid hostname. You can also use your own certificate.
So this is exactly what we're doing.

Copy Easy-RSA, rename vars example and edit it
^^^^^^^^^^^^^^^^

.. code-block:: console

    cp -R /usr/share/easy-rsa/ .
    cd easy-rsa
    mv vars.example vars
    sudo nano vars

We already covered the purpose of each one of these commands in our CA Session, so we are summing this up for simplicity.
What matters here is the content of vars. We will be changing it as we did before but with some different information just for the sake of it.

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
    set_var EASYRSA_REQ_CITY "Halifax"
    set_var EASYRSA_REQ_ORG "Safehouse - GitLab Server"
    set_var EASYRSA_REQ_EMAIL "gitlab@safehouse.com"
    set_var EASYRSA_REQ_OU "Safehouse - GitLab Server"

Initialize the Public Key Infrastructure (PKI)Title
^^^^^^^^^^^^^^^^

.. code-block:: console

    ./easyrsa init-pki

Initialize the PKI directory where certificates and keys will be stored.

Generate a certificate request for GitLab
^^^^^^^^^^^^^^^^

.. caution::

   Slow down and pay attention!

The command below generates a certificate request for the GitLab server without a password.
You will be once again asked to fill several fields during this process. For most of them, you can simply press `Enter`` to accept the default value. However, when prompted for `"Common Name"`, make sure to enter "gitlab.safehouse.com".
This is an important step as you will have to restart this session if you get this wrong, so no pressure.

.. code-block:: console

    ./easyrsa gen-req gitlab nopass

.. note::
    As soon as the key is generated, copy the following paths for later use:
        req: /home/ubuntu/easy-rsa/easy-rsa/pki/reqs/gitlab.req
        key: /home/ubuntu/easy-rsa/easy-rsa/pki/private/gitlab.key
    We will be using them in a while in the `/etc/gitlab/ssl` directory, so pay attention to their path.

Create the SSL directory
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo mkdir -p /etc/gitlab/ssl
    sudo chmod 755 /etc/gitlab/ssl

Create the SSL directory for GitLab and set the correct permissions.

---------------------

Intermission - CA Setup (CA and Gitlab VM)
~~~~~~~~~~~~~~~~

.. caution::

   Slow down and pay attention, again!

Here is the second highlighted warning as promised. We will be changing VM's terminals for a while, so it's easy to get lost.
Along with every title, we will be pointing out which VM terminal you should be using by referring to them as CA (for the DNS/CA VM) or Gitlab (for the Gitlab VM).
Be careful as you can copy and/or paste things inside the wrong terminal.

Navigate to the reqs directory (CA)
^^^^^^^^^^^^^^^^

.. code-block:: console

    cd pki/reqs/

Change the working directory to the reqs directory inside the PKI structure.

.. tip::

    If you exited the DNS/CA VM and just came back, you can manually find the directory inside the Easy-RSA folder.

Create and edit the gitlab.req file (CA)
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo nano gitlab.req

Create and open the gitlab.req file with nano. Leave the terminal open and switch to the Gitlab terminal.

Copy the Certificate Request (Gitlab)
^^^^^^^^^^^^^^^^

.. code-block:: console

    cat pki/reqs/gitlab.req

Once inside the GitLab Multipass terminal, use this command to retrieve the information from the file `pki/reqs/gitlab.req`.
Then switch back to the open text editor in the CA terminal.

Paste the Certificate Request (CA)
^^^^^^^^^^^^^^^^

With the content from the Gitlab VM copied, paste it as shown below (to be replaced):

.. code-block:: console 

    -----BEGIN CERTIFICATE REQUEST-----
    MIIDBDCCAewCAQAwgb4xCzAJBgNVBAYTAkJSMQswCQYDVQQIDAJQUjETMBEGA1UE
    BwwKR3VhcmFwdWF2YTEjMCEGA1UECgwaTXlQcm9ibGVtcyAtIEdpdExhYiBTZXJ2
    ZXIxIzAhBgNVBAsMGk15UHJvYmxlbXMgLSBHaXRMYWIgU2VydmVyMR4wHAYDVQQD
    DBVnaXRsYWIubXlwcm9ibGVtcy5jb20xIzAhBgkqhkiG9w0BCQEWFGFkbmlyQG15
    cHJvYmxlbXMuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiXPm
    5wFB4yXaNaW5/tvQ/PXNKByjkIh0H8sU8Qwo9mKAWFYkygACvYkhE2kJ2D2xXPMi
    ape7PtQwMs/FlSw1zaa8HZyjX+JtEPtsr9Lq3AhbMaplNWRwMXRBdaNDmXzag2sS
    p2/acLP3AcbqG3GR8sjsc/dgmdDWmqT5DFCJrXt2w2VNczbq/Q2Ud1o8rzexoT0A
    C4Ro5DKYOXCzx7aM1eMux6MixgzSwWCrSK3/y8kwW2v7rZN0X+diJfwhxdNmQ92A
    ZzWxtGZ/7nmBZe8aO23ZXV5r7NiONrtJVrHo33iA9Y0GguXOLjG66jpLaKELtW15
    njFxCxmhObVz/pfoKQIDAQABoAAwDQYJKoZIhvcNAQELBQADggEBABIMUxWlyWmb
    SLjz+B8mZgj/M++K+4lZtNabUZmdfSY9N6cvgL+P9P5MRTxk9fzxmB2QKycnmekC
    MCbSpRs5eV8JOH3fz041gD7XxLEe4UoAD+vQ9hZcBElIu0WR9V4AVqVUKRvR7Qte
    fU6+ymSgffDkD9Nnjm13GTIGymH+f+dNWoGJ9n61pRVnAxsUFFP8zGdiaTUXAIjj
    4EnlxgGeHHnLGKxAaPzHM3yeThXJhh8/+Fo2lQIMgWb/MNE0URvDj8mbhs/e2bBD
    wU3kvOMztoJOnJ+TjC+LDK//jvOyo0JCz/UmbLyjAXdRBj6u4Xc0z8HSPCJcpSmO
    YE5cpdLJJjs=
    -----END CERTIFICATE REQUEST-----

.. caution::

    Ensure to replace the code above with the actual content retrieved from `gitlab.req` within the GitLab VM.

Return to the Easy-RSA directory and Sign the server request (CA)
^^^^^^^^^^^^^^^^

.. code-block:: console

    cd ../..
    ./easyrsa sign-req server gitlab

Navigate back to the Easy-RSA root directory and sign the server request with your CA.
You will be prompted to confirm and enter the CA password, which - luckily - you wrote down as instructed by the author of this documentation.
If you did write it down, you can safely switch back to your Gitlab VM. If you don't remember your password, this author is simply sorry for you.

Create the GitLab SSL certificate file (Gitlab)
^^^^^^^^^^^^^^^^

.. code-block:: console

    cd /etc/gitlab/ssl
    sudo nano gitlab.safehouse.com.crt

Now, access your `/etc/gitlab/ssl` directory and create a new file to paste the SSL certificate for GitLab.
This part can be a handful, so keep focused. Leave your Gitlab VM's terminal open, we're going back to the CA VM.

Copy the issued GitLab certificate and CA certificate (CA) 
^^^^^^^^^^^^^^^^

.. code-block:: console

    cat pki/issued/gitlab.crt

Inside the CA VM, use the cat command mentioned above to retrieve the issued GitLab certificate.
Copy everything from `-----BEGIN CERTIFICATE-----` to `-----END CERTIFICATE-----`, and paste it into a text editor on your host."
Now, go back to the terminal and use the following:

.. code-block:: console

    cat pki/ca.crt

Copy all of its content and paste it into your host's text editor, directly below the `-----END CERTIFICATE-----` part.
As a result, the content of your local text editor must be two certificates, one right above the other, looking something like this:

.. code-block:: console 

    -----BEGIN CERTIFICATE-----
    MIIFUzCCBDugAwIBAgIQe1/uVzdcXis8CP+T3rk2jjANBgkqhkiG9w0BAQsFADCB
    qTELMAkGA1UEBhMCVVMxEzARBgNVBAgMCkNhbGlmb3JuaWExFjAUBgNVBAcMDVNh
    biBGcmFuY2lzY28xFjAUBgNVBAoMDU15UHJvYmxlbXMgQ0ExFjAUBgNVBAsMDU15
    UHJvYmxlbXMgQ0ExGTAXBgNVBAMMEG15cHJvYmxlbXNjYS5jb20xIjAgBgkqhkiG
    9w0BCQEWE21lQG15cHJvYmxlbXNjYS5uZXQwHhcNMjQwNjE2MTYxNzUzWhcNMjYw
    OTE5MTYxNzUzWjCBvjELMAkGA1UEBhMCQlIxCzAJBgNVBAgMAlBSMRMwEQYDVQQH
    DApHdWFyYXB1YXZhMSMwIQYDVQQKDBpNeVByb2JsZW1zIC0gR2l0TGFiIFNlcnZl
    cjEjMCEGA1UECwwaTXlQcm9ibGVtcyAtIEdpdExhYiBTZXJ2ZXIxHjAcBgNVBAMM
    FWdpdGxhYi5teXByb2JsZW1zLmNvbTEjMCEGCSqGSIb3DQEJARYUYWRuaXJAbXlw
    cm9ibGVtcy5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCJc+bn
    AUHjJdo1pbn+29D89c0oHKOQiHQfyxTxDCj2YoBYViTKAAK9iSETaQnYPbFc8yJq
    l7s+1DAyz8WVLDXNprwdnKNf4m0Q+2yv0urcCFsxqmU1ZHAxdEF1o0OZfNqDaxKn
    b9pws/cBxuobcZHyyOxz92CZ0NaapPkMUImte3bDZU1zNur9DZR3WjyvN7GhPQAL
    hGjkMpg5cLPHtozV4y7HoyLGDNLBYKtIrf/LyTBba/utk3Rf52Il/CHF02ZD3YBn
    NbG0Zn/ueYFl7xo7bdldXmvs2I42u0lWsejfeID1jQaC5c4uMbrqOktooQu1bXme
    MXELGaE5tXP+l+gpAgMBAAGjggFeMIIBWjAJBgNVHRMEAjAAMB0GA1UdDgQWBBQR
    5PhhNucobErOVdimZCXkV4n91jCB6QYDVR0jBIHhMIHegBRBfdqX4Cy9SdJ5eQYM
    BHvgwpYlpaGBr6SBrDCBqTELMAkGA1UEBhMCVVMxEzARBgNVBAgMCkNhbGlmb3Ju
    aWExFjAUBgNVBAcMDVNhbiBGcmFuY2lzY28xFjAUBgNVBAoMDU15UHJvYmxlbXMg
    Q0ExFjAUBgNVBAsMDU15UHJvYmxlbXMgQ0ExGTAXBgNVBAMMEG15cHJvYmxlbXNj
    YS5jb20xIjAgBgkqhkiG9w0BCQEWE21lQG15cHJvYmxlbXNjYS5uZXSCFHsqrBHj
    D/CsfTEVR2exPicJDSEJMBMGA1UdJQQMMAoGCCsGAQUFBwMBMAsGA1UdDwQEAwIF
    oDAgBgNVHREEGTAXghVnaXRsYWIubXlwcm9ibGVtcy5jb20wDQYJKoZIhvcNAQEL
    BQADggEBAGPZLyM01Th2U0lrXeLDlUD5YCkwsCvwCR+HcRVQYT3/r0jj97PL37vj
    zKbmE7HM0MOQBjDYPKlx3Nyzyy5w67TRY3YwByaLkuq9qttS8XkqW1n+qh5O9HZU
    gekWidjsFSLYEKe2TefZZtj1dSdF3wE8X5mMFI0o/4DCeodKeudZxxPKOG7wvQsb
    C76YhW1UywZYbcgysN1Zu4YCjMOgioak53th6QE2N6mDZ7JtoD+c3Uy+SEmOhqQk
    nvdJ2dA1NpdNSxe/3jyp2Ux1QDKbkKiECE5nm6fZGqQHBTu6HBn5vqZjhAGV8qL7
    k8q7fu7CjK8ZcoR2WeQv2c1PyIOr6Ak=
    -----END CERTIFICATE-----
    -----BEGIN CERTIFICATE-----
    MIIFDjCCA/agAwIBAgIUeyqsEeMP8Kx9MRVHZ7E+JwkNIQkwDQYJKoZIhvcNAQEL
    BQAwgakxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlhMRYwFAYDVQQH
    DA1TYW4gRnJhbmNpc2NvMRYwFAYDVQQKDA1NeVByb2JsZW1zIENBMRYwFAYDVQQL
    DA1NeVByb2JsZW1zIENBMRkwFwYDVQQDDBBteXByb2JsZW1zY2EuY29tMSIwIAYJ
    KoZIhvcNAQkBFhNtZUBteXByb2JsZW1zY2EubmV0MB4XDTI0MDYxNjE1MDIxMFoX
    DTM0MDYxNDE1MDIxMFowgakxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApDYWxpZm9y
    bmlhMRYwFAYDVQQHDA1TYW4gRnJhbmNpc2NvMRYwFAYDVQQKDA1NeVByb2JsZW1z
    IENBMRYwFAYDVQQLDA1NeVByb2JsZW1zIENBMRkwFwYDVQQDDBBteXByb2JsZW1z
    Y2EuY29tMSIwIAYJKoZIhvcNAQkBFhNtZUBteXByb2JsZW1zY2EubmV0MIIBIjAN
    BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA16Zr16xRnsS+/0tDC65YaKds9SSU
    e0BMa7rqMwWazd7jYEf78oq1k4gF7CKobc2Tsdq1dkLCJm4hcsp/dUCUMGtyJlu+
    7mf83B8SS8d+Ws8nkXepjW98QWMBRYWF0KhABPdx0a7I9jA3IEz/mij/27A7/5rq
    S29BM9l9uh3ob5s0YtcWIxAR8yCtyAFrm18oGTOONpNOZfvjzB4N1nTuHb0JkeBP
    QWw+NYxmeu/t6aa/71+suzGtmWqcGaIs9IVg1Hu2HUeVvdSyakLomKOD8lW31W+0
    8x9hTj60AVUynsFmogUS7LAkw7HOu/qUQUGY5T2C8xUqY5w6wBby+mZLcQIDAQAB
    o4IBKjCCASYwHQYDVR0OBBYEFEF92pfgLL1J0nl5BgwEe+DCliWlMIHpBgNVHSME
    geEwgd6AFEF92pfgLL1J0nl5BgwEe+DCliWloYGvpIGsMIGpMQswCQYDVQQGEwJV
    UzETMBEGA1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzEW
    MBQGA1UECgwNTXlQcm9ibGVtcyBDQTEWMBQGA1UECwwNTXlQcm9ibGVtcyBDQTEZ
    MBcGA1UEAwwQbXlwcm9ibGVtc2NhLmNvbTEiMCAGCSqGSIb3DQEJARYTbWVAbXlw
    cm9ibGVtc2NhLm5ldIIUeyqsEeMP8Kx9MRVHZ7E+JwkNIQkwDAYDVR0TBAUwAwEB
    /zALBgNVHQ8EBAMCAQYwDQYJKoZIhvcNAQELBQADggEBAB3foNz69WM1IV6t7t7s
    DoS0ktunag+Twmm/KK1/XsBq2gy4SV0/DBe/XXZWOAi3HysP+o8HXbVAra5iwxeM
    pba+Tl3101cnN9HnUjK+QVVeO5atWdoqow3VbpnRsncEHyfHNJqC0guKrrtqSx4V
    BYmK75devVUHNg5jFFceq860LiYu2F2oQZGN0sOfnnfFi3fm8cpUqsn4tJ0sLldu
    N2lw2Rxj6L9O+dhHwamdQ8KhYnFJ6qenshjryr9Dt3Q+QOElMhwEVU+FutY14gbN
    grIhu8jQWKkH103snaB9mvgg2bluqyrhdy3PaKnszjQhak0xgrLhJNqaxZ0GaWz6
    wHs=
    -----END CERTIFICATE-----

With this part done, you're free from the CA VM. But the terror persists.

Paste the combined certificates (Gitlab) 
^^^^^^^^^^^^^^^^

Back to the Gitlab VM's terminal, we're welcomed by the nano editor still open, waiting for us. Copy the content from your host text editor and paste it inside the `gitlab.safehouse.com.crt` file and save it.

Copy the GitLab key to the SSL directory (Gitlab)
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo cp ~/easy-rsa/easy-rsa/pki/private/gitlab.key /etc/gitlab/ssl/gitlab.safehouse.com.key
    sudo chmod 664 /etc/gitlab/ssl/gitlab.safehouse.com.crt

Copy the GitLab private key to the SSL directory and set the correct permissions.

.. tip:: 
    If your key's path is wrong, remember that we got the right path in the `Generate a certificate request for GitLab` step in this very session.

---------------------

GitLab Setup - Finally Installing
~~~~~~~~~~~~~~~~

Now that our CA is properly configured, issued and placed, we can finally finish our local GitLab installation by:

Install GitLab CE
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo EXTERNAL_URL="https://gitlab.safehouse.com" apt-get install gitlab-ce

Installing GitLab Community Edition, specifying the external URL for GitLab.

Retrieve and save the GitLab root password
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo cat /etc/gitlab/initial_root_password | egrep Password

Retrieve the initial root password for GitLab and save it for logging into the system.

.. caution:: 
    Save the password somewhere else. You will need it in the next steps, and resetting it it's a pain.

---------------------

GitLab Setup - SMTP settings
~~~~~~~~~~~~~~~~

Soon enough, we will need to send some e-mails so people can join our projects in our local GitLab. We will be doing so by configuring an SMTP server using Gmail.
This is the easiest part of this whole guide, but you will need to generate an "App Password". You can get one in your Gmail Account Settings.
This guide won't be covering how to get an App Password, but you can find how to do it `here <https://support.google.com/mail/answer/185833?hl=en>`_.
But as for our part, all you need to do is:

Edit the GitLab configuration file
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo nano /etc/gitlab/gitlab.rb

Open the GitLab configuration file with nano to configure your SMTP. You can replace the content with the following:

.. code-block:: console
    
    gitlab_rails['smtp_enable'] = true
    gitlab_rails['smtp_address'] = "smtp.gmail.com"
    gitlab_rails['smtp_port'] = 587
    gitlab_rails['smtp_user_name'] = "your-email@gmail.com"    # REPLACE THIS WITH YOUR GMAIL E-MAIL
    gitlab_rails['smtp_password'] = "INSERT APP PASSWORD HERE"  # REPLACE THIS WITH YOUR APP PASSWORD
    gitlab_rails['smtp_domain'] = "gmail.com"
    gitlab_rails['smtp_authentication'] = "login"
    gitlab_rails['smtp_enable_starttls_auto'] = true
    gitlab_rails['smtp_tls'] = false
    gitlab_rails['gitlab_email_from'] = 'safehouse-lab@gmail.com'
    gitlab_rails['gitlab_email_reply_to'] = 'safehouse-lab@gmail.com'

    gitlab_rails['smtp_openssl_verify_mode'] = 'peer'
    gitlab_rails['smtp_ssl'] = false

    gitlab_rails['gitlab_email_display_name'] = 'Safehouse GitLab'

.. note::

   Don't forget to replace your `smtp_user_name` and `smtp_password` as stated above.

Reconfigure GitLab
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo gitlab-ctl reconfigure

Apply the configuration changes by reconfiguring GitLab.

---------------------

And it's over!! This part, at least.
You can now access your local GitLab instance at https://gitlab.safehouse.com. If you are already tired, imagine how your computer feels with all those VMs. But don't worry, it will get worse!
For now, let's take a moment to configure our Gitlab so we can finally configure our GitLab Runner and start developing our application.

See you in the next part of this documentation.