About this Project
===================

How to use this documentation
------------------

Welcome to the documentation for "The Safehouse" project, developed as part of the "Cloud Development and Operations" course at UTFPR/GP. This guide will help you set up and work with various components of the project.

------------------

Key Sections Covered
~~~~~~~~~~~~~~~~~~~~~

1. Setting Up Your DNS and Certificate Authority (CA)
^^^^^^^^^^^^^^^^

Learn how to configure your DNS settings and set up a Certificate Authority.

2. Installing and Setting Up GitLab Locally
^^^^^^^^^^^^^^^^

This section provides detailed instructions on how to install and configure GitLab on your local machine. GitLab will be used to manage your project repositories and CI/CD pipelines.

3. Installing and Configuring Your GitLab Runner
^^^^^^^^^^^^^^^^

Follow these steps to install and set up a GitLab Runner, which will execute your CI/CD jobs. The GitLab Runner will be configured to use Docker-in-Docker (DinD) for containerized builds and tests.

------------------

Working with "The Safehouse" Project
~~~~~~~~~~~~~~~~~~~~~

The documentation guides you through working with "The Safehouse" project using GitHub as an example. However, as you will be working with your local GitLab, you can follow the same steps, but substituting the GitHub repository with your local GitLab repository.
Example:

Instead of:
    GitHub: git clone https://github.com/adnir-andrade/safehouse.git
Use:
    GitLab: git clone http://your-gitlab-instance/your-repo/safehouse.git

------------------

Pipeline Overview
~~~~~~~~~~~~~~~~~~~~~

Build and Test Pipeline
^^^^^^^^^^^^^^^^

The CI/CD pipeline is designed to build and test the project using a Docker-in-Docker (DinD) setup within the GitLab Runner VM. This ensures that all builds and tests are run in a consistent and isolated environment.

Deployment
^^^^^^^^^^^^^^^^

At the end of the pipeline, the backend of "The Safehouse" project is deployed inside the same container. You can then start the frontend locally, as it is preconfigured to connect to the backend server running on `0.0.0.0:3000`.

------------------

Virtual Machines with Multipass
~~~~~~~~~~~~~~~~~~~~~

All components, including the DNS/CA, GitLab, and GitLab Runner, are set up to run inside Virtual Machines managed by Multipass. This setup ensures a clean and isolated environment for each component, simplifying the management and deployment process. But beware, as your RAM usage will be over the top.

------------------

With all of this in mind, we can now start this not-too-exciting journey by configuring our DNS VM.