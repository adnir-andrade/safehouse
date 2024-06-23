GitLab Runner 
===================

Installation and Configuration Guide
-----------------

We're almost ready to start developing our application. For now, we need two things:

1) Invite new developers to your GitLab project
   
2) Configure our first GitLab Runner

The first step we won't be covering, as it's pretty straightforward and, if you managed to get to this point of the documentation, inviting someone is the least of your problems.
With your SMTP already configured, it is as easy as it gets. But if you really want to get into details, you can always check `GitLab own article about this <https://docs.gitlab.com/ee/user/project/members/>`_.

What will cover, though, is how to configure your first GitLab Runner, as it's easier than anything we did so far, but not as simple as it could be. So first thing first, you should start a new VM on Multipass, and then proceed.

---------------------

GitLab Runner Setup - Pre-Installation
~~~~~~~~~~~~~~~~

This is what you need to do in order to install your first Runner.

Transfer the CA Certificate
^^^^^^^^^^^^^^^^

.. code-block:: console

   multipass transfer ~/Path/To/Your/ca.crt gitlab-runner:/home/ubuntu

Remember back at the CA Session when the author of this documentation told you to download the certificate? This is where it comes in handy.

Just make sure the first path is where the ca.crt is downloaded in your local machine, and then that `gitlab-runner` is how you named your VM.
If you named your VM anything but gitlab-runner, then change the name of the VM on the command, or if you are feeling lazy simply create another VM named `gitlab-runner`.
If you correctly pass those arguments, multipass should copy the ca.crt file from your local machine to the home directory of the ubuntu user in the gitlab-runner VM. Neat.

Save the Certificate
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo mv ~/ca.crt /usr/local/share/ca-certificates/

Next, move the certificate to the appropriate directory. This command moves your ca.crt to the `/usr/local/share/ca-certificates/` directory where it will be recognized by the system.

.. note:: 
    Don't try to use `multipass transfer` to transfer directly to this path. Multipass can't do this because of permissions issues.

Update CA Certificates
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo update-ca-certificates

This command refreshes the list of recognized CA certificates on the system, incorporating your newly added certificate.

---------------------

GitLab Runner Setup - Installing
~~~~~~~~~~~~~~~~

We will now proceed to install our Runner.

Add the GitLab Runner package repository and install the package
^^^^^^^^^^^^^^^^

.. code-block:: console

    curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash

This command uses curl to download and run the GitLab Runner installation script. It adds the GitLab Runner repository to your system's package manager.

Install GitLab Runner
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo apt-get install gitlab-runner

Finally, this command installs the GitLab Runner package from the newly added repository.

---------------------

GitLab Runner Setup - Adding a Runner in GitLab
~~~~~~~~~~~~~~~~

Before we can proceed with configuring our Runner, we need to make sure that GitLab understands that this runner that we've just installed is going to be used in this project.

Access GitLab
^^^^^^^^^^^^^^^^

We start by accessing our local GitLab as root. Remember, the main user is `root` and the password is the one you wrote down in the last session.

So go to https://gitlab.safehouse.com and do it.

Navigate to Project Settings
^^^^^^^^^^^^^^^^

Once logged in, go to the project where you want to add the Runner. If you didn't create a project for the Safehouse, do so now. Click on the project to open it.

Go to CI/CD Settings
^^^^^^^^^^^^^^^^

In the project navigation menu, go to `Settings -> CI/CD`

Scroll down to the "Runners" section, click on the "Expand" button next to the "Runners" section to see the configuration options.

Register a New Runner
^^^^^^^^^^^^^^^^

Under the "Set up a specific Runner manually" section, you will find a registration token and instructions for registering a new Runner.

Copy the registration token. You will use this token to register the Runner on the GitLab-Runner VM.

---------------------

GitLab Runner Setup - Configuring
~~~~~~~~~~~~~~~~

Now, we're ready to configure our VM. Fairly simple, yet overly complicated.

Register a New Runner
^^^^^^^^^^^^^^^^

.. code-block:: console

    sudo gitlab-runner register

The registration process will begin. During this process, you will be prompted for several details. You must fill them accordingly to:
- GitLab instance URL: `https://gitlab.safehouse.com`
- Registration token: Paste the registration token you copied earlier.
- Description: Anything that you like
- Tags: Optional, provide tags to categorize the Runner if you want.
- Executor: Choose the executor `docker` for the Runner, as we are going to use Docker DIND.
- Docker Image: `docker:latest`

After completing the registration, return to the GitLab web interface to verify that the Runner appears in the "Runners" section of your project. If it does, you can proceed to the next part.

Edit config.toml
^^^^^^^^^^^^^^^^
.. code-block:: console

    sudo nano /etc/gitlab-runner/config.toml

Next, you need to edit the `config.toml`` file on the GitLab Runner VM. Opening it with nano, you can modify the runners.docker section to the following configuration:

.. code-block:: console

    [runners.docker]
        tls_verify = false
        image = "docker:latest"
        privileged = true
        disable_entrypoint_overwrite = false
        oom_kill_disable = false
        disable_cache = false
        volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache", "/certs/client"]
        shm_size = 0
        network_mtu = 0

This will guarantee that our Docker DIND work as intended.

---------------------

And finally! You're ready to start developing using GitLab.

In the next session, you will find some basic instructions for a new Dev to start working on the project. But mostly, the hard work is done.

Pat yourself in the back and congratulations!