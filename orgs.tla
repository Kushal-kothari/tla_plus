-------------------------------- MODULE orgs --------------------------------

(*
One organization can have several groups
A group can only have one organization
This is a one to many relationship between organizations and groups

One group can have multiple locations
A location can only have one group
This is a one to many relationship between groups and locations

One location can have multiple users
One user can have multiple locations
This is a many to many relationship between users and locations

A user can have one or fewer roles 
Roles are actually templates, not roles in a security sense
A Role can be assigned to multiple users
This is a one to many relationship between roles and users

Users can have multiple permissions
A permission can be assigned to multiple users
This is a many to many relationship between permissions and users
*)

