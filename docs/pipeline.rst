GitLab CI/CD Pipeline Guide
===================

Pre-requisites for Development:
-----------------

Before starting development on the Safehouse project, ensure you have completed the following steps:

1) Install Git
~~~~~~~~~~~~~~~~

Git is essential for version control. Follow the installation guide for your operating system:

- `Git <https://git-scm.com/book/en/v2/Getting-Started-Installing-Git>`_

2) Generate an SSH Key
~~~~~~~~~~~~~~~~

Generating an SSH key is crucial for secure communication with GitLab. Follow this guide to generate an SSH key:

- `Generating a new SSH key and adding it to GitLab <https://docs.gitlab.com/ee/user/ssh.html>`_

3) Request Development Permissions
~~~~~~~~~~~~~~~~

Ensure you have the necessary permissions to develop on the project. Contact the project maintainer in GitLab to request access.

4) Install Ruby, Rails, and TypeScript
~~~~~~~~~~~~~~~~

Ensure you have the necessary programming languages and frameworks installed for development:

- `Install Ruby <https://www.ruby-lang.org/en/documentation/installation/>`_

- `Install Rails <https://guides.rubyonrails.org/v5.0/getting_started.html>`_

- `Install TypeScript <https://www.typescriptlang.org/download/>`_

5) Read the Documentation
~~~~~~~~~~~~~~~~

Make sure to read the documentation for both the Backend and Frontend sections, which are available at the end of this documentation. They are shorter and more objective, I promise.


.. tip:: text

    By following these steps, you will be ready to start developing on the Safehouse project. If you encounter any issues or need further assistance, please reach out to the project maintainer.

-----------------

Pipeline Guide:
-----------------

Branching and Merge Requests
~~~~~~~~~~~~~~~~

Before starting work on a new feature, the developer should create a new branch. Ensure that both the build and tests pass successfully on this branch before creating a merge request.

-----------------

Pipeline Stages
~~~~~~~~~~~~~~~~

The pipeline for this project consists of the following stages:

1) Cleanup
^^^^^^^^^^^^^^^^

This stage ensures that any previous Docker containers, images, and volumes are removed before starting a new build. This prevents potential conflicts and ensures a clean environment.

2) Build
^^^^^^^^^^^^^^^^

In the build stage, Docker Compose is used to build the images and start the services. It also sets up the database for both development and testing environments.

This process is slow, and it can take up to 15 minutes to finish.

3) Test
^^^^^^^^^^^^^^^^

This stage runs the RSpec tests to ensure that the application is functioning correctly. The tests are executed within the Docker container.

4) Deploy
^^^^^^^^^^^^^^^^

In the final stage, the application is deployed by starting the Rails server. This allows the application to be accessible at `0.0.0.0:3000`` (or simply localhost:3000).

This stage only run on the main branch. So to develop, clone the project, and work on it locally.

-----------------

Now you know everything there is to know about Safehouse's GitLab.

In the next pages, you will learn how to clone and start working on each of the repositories of this monorepo.

Good luck, and may your code never break!