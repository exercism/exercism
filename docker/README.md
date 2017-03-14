# Docker and exercism.io

Optionally, one can develop (and even deploy) exercism.io using a tool
called Docker. The primary advantage of using it is that you don't have to
install a ton of dependencies--like a ruby version manager, ruby, postgres,
nodejs, and a bunch of Ruby gems--on your own system. The disadvantage,
however, is that you may need to acquaint yourself with Docker, and you
need a 64-bit machine.

For a basic overview, see [What is Docker?][] on the Docker website.

**Note:** At the present time, developing the front-end via Docker
isn't working, but this will hopefully be remedied soon.

## Installing Docker

### Linux

First, you'll want to install [Docker Engine][] if you haven't already.

Then install Docker Compose:

    curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

### Mac (Yosemite [10.10.3] and Up)

Please install [Docker for Mac][]. The fastest and easiest way to get started
with Docker on Mac.

### Windows (Windows 10 Professional or Enterprise 64-bit)

Please install [Docker for Windows][]. The fastest and easiest way to get
started with Docker on Windows PC.

### Other Platform Versions

Please install [Docker Toolbox][]. This will ensure that you have
Docker, Docker Machine, and Docker Compose on your system.

Finally, make sure all future work with this project is done via the
**Docker Quickstart Terminal**, *not* your standard terminal or
command prompt. Using this special terminal is critical because it
sets up some environment variables and services that are required for
Docker to work on your platform.

Note that on your operating system, the hard work is all being done
behind-the-scenes by a Linux-based virtual machine. The software used
to communicate between your OS and the VM is called [Docker Machine][].
This indirection can sometimes cause confusion and difficulties, but
this document will try to address potential issues when they may arise.

**Note to Windows Users:** Due to various Windows issues, it's
probably easiest to develop by setting up a Linux virtual machine
using a tool like [VirtualBox][], and following the Docker instructions
for Linux, rather than using Docker Toolbox on Windows. However, you're
welcome to give it a shot!

## Setting up exercism.io

First, create an `.env` file in the root of your repository with
the following in it:

```
EXTERNAL_PORT=4567
```

You may also want to set up GitHub OAuth as per the instructions in
[`CONTRIBUTING.md`][], in which case you can add your GitHub OAuth
credentials, too:

```
EXERCISM_GITHUB_CLIENT_ID=your_github_oauth_client_id
EXERCISM_GITHUB_CLIENT_SECRET=your_github_oauth_client_secret
```

Then run:

    docker-compose build

This will take a little while as a few Docker containers are built for
you. Once it's finished, run:

    docker-compose run app bin/setup

Now your database is set up. To get the site up and running, run:

    docker-compose up

If you're on Linux, your development instance of exercism.io will be running
at http://localhost:4567.

Otherwise, if you're on a system using Docker Toolbox, your development
server will actually be running on your Docker Machine VM, *not* on
localhost. So to visit your development instance, you will need to
go to the IP address you get from running the following command:

    docker-machine ip default

Suppose this command tells you that your Docker Machine VM is at
192.168.99.100. Then your development instance of exercism.io will be at
http://192.168.99.100:4567.

## Changing The Port

By default, the app will be exposed at port 4567, but you can change this
by altering the value of `EXTERNAL_PORT` in your `.env` file.

## Updating Dependencies

Whenever the project's dependencies change (e.g., when a new gem is added
to the `Gemfile`), you will need to re-run `docker-compose build`.

## Other Tasks

In general, anything in the developer documentation that runs on the
command-line should be prefixed with `docker-compose run app`.

### Bash

You can just run `docker-compose run app bash` to launch a shell in the
app container and run programs directly from there.

The `/exercism` directory is mapped directly to your repository checkout.

### Running Tests

Before running tests, run:

    docker-compose run app rake db:migrate RACK_ENV=test

Then, to run all tests, run:

    docker-compose run app rake

To run a single test suite, you can do so with:

    docker-compose run app ruby path/to/the_test.rb

### Console

The console mentioned in [`CONTRIBUTING.md`][] can be run via:

    docker-compose run app bin/console

## Uninstalling

If you decide this solution isn't for you, you'll want to run a few
commands to free up some Docker resources that exist outside of the
repository directory. From the root of the repository, run:

```
docker-compose stop
docker-compose rm
docker rmi exercismio_app
docker rmi exercismio_compass
```

  [What is Docker?]: https://www.docker.com/what-docker
  [Docker Engine]: https://docs.docker.com/engine/installation/
  [Docker Machine]: https://docs.docker.com/machine/
  [Docker Toolbox]: https://www.docker.com/toolbox
  [Docker for Mac]: https://www.docker.com/docker-mac
  [Docker for Windows]: https://www.docker.com/docker-windows
  [VirtualBox]: https://www.virtualbox.org/
  [`CONTRIBUTING.md`]: https://github.com/exercism/exercism.io/blob/master/CONTRIBUTING.md
