# Sylar #

## "Killer time tracking for freelancers and other superheroes." ##

This is a quick little project featuring:

* A diary similar to Backpack's new Journal feature
* Simple time tracking, with notes and billable/unbillable flag 
* Whatever other simple stuff I think of

### Context switching ###

*The problem:* You're in the middle of a task for a client or project. You've been at it for an hour or two, then let's say a different client calls and you need to switch gears. You can't leave the clock running for Client A while you talk to Client B.

*The (possible) solution:* Sylar has what I'm calling "tasks," which is really just another way of saying 'this is what I'm doing right now.' Tasks have a state (opened, sleeping or finished). Whenever a task is opened, if you have any other open tasks they're automatically put to sleep. Whenever a task is put to sleep or finished, a journal entry for the time you've spent on that task is automatically created. Switching contexts is as easy as just starting or resuming a task, which can be done in a single click.