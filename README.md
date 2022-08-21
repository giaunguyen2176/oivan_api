# 1. Run the application at local development environment

Open terminal and go to project root directory.

Run the following command:
    
    docker-compose up -d --build

2 docker containers will be started:

- A localhost postgres container running at port 9432 on host machine or port 5432 inside container machine
- A Rails application running at port 9000 on host machine or port 3000 inside container machine.

Open up your web browser, and enter: `http://localhost:9000/api-docs`, a swagger documents detail how to test all the endpoints provided by the service.


# 2. Potential security issue/vulnerability

## 2.1. Background

To provide encode/decode ability, the service is using a library called hashids (https://hashids.org), which provide the
capability to encode integer ids such as: 1020, 30300, ... into BASE-62 version for example: 8wkeQQ, ie89QHI, ... which 
can then be used in a URL shortening service. 

This kind of "integer to string" translation basically use an ALPHABET, usually combined of all uppercase, lowercase and number
characters (62 characters in total - BASE-62), and a base conversion algorithm to translate the number into its 
counter-version of the provided ALPHABET. 

## 2.2. Brute force attack

Even though you keep your ALPHABET secret, because of the nature of URL shortening service, the url cannot be too long,
hence makes it vulnerable to Brute force attack. 

Use your service long enough, you will have all the data you need to figure out how an id is mapped to a string and what
your secret ALPHABET is. A bad actor can then reverse engineering, decode and get all the URLs in your system.

The library implemented additional method to lower the ability that someone might crack your service by combining a 
SECRET SALT with your secret ALPHABET, shuffle that to produce a new random ALPHABET. 

This does not completely protect the service from Brute force attack, so you should deploy the service along with other 
counter measures such as DDOS protection, API usage throttling, IP blocking, ... to minimize the change of someone cracking the code.


#3. Scaling the service

There are no collisions because the method is based on integer to hex conversion. As long as you don't change constructor 
arguments midway, the generated output will stay unique to your salt.

The only bottom neck for this service is the database used to store and get the original urls, there are couple of options to 
scale the service in case the database reached its limit. You can scale up the database instance until you still can afford it
or it's still feasible in cost. 

When scaling up is not an option anymore, you can try setting replica set, with some additional rule of 
splitting read traffic to specific instances in the replica set, saving the bandwidth for write traffic to the master. 

This may produce synchronization problem to your service, since data from the master instance may take sometime to be completely
synced to all the replica instances. In order to combat this, we can use some intermediate caching layer such as Redis to 
temporary serve the data to the user while waiting for the data to be available across all database instances.

Caching layer such as Redis could also be used to increase the performance of the service if you want even more speed and through put.

#4. The limitation

In the future, if the SECRET SALT or ALPHABET is somehow leaked, that may exposes all your stored URLs, you need
to change the SECRET SALT. This will makes all old URLs unreachable since old key cannot be decoded back to id using a different SECRET SALT.

There is no perfect way to counter this, one work around would be keeping the current, leaked SECRET SALT, so that 
all old URLs are still reachable, also adding a new SECRET SALT and start encoding new URLs using new SALT or replace the old SALT with 
a new one and writing a service to redirect old keys to its origin URLs. 

A more advance solution is to use multiple different SALTs, and implement a mechanism to allow mapping back from the key
to its SALT so that it can be decoded using the proper SALT. And then add a new SALT to the list of SALTs every fixed period of time,
that way say every 24 hours or so, a new SALT is added, new URLs start to be encoded using new SALTs.

Then, when leaked or exposed, only a small part of all of your encoded URLs are exposed, the remaining/new URLs are still safe.

But remember to always keeps the SECRET a secret.