Update
-------
The tumblr api v1 became deprecated so this little library became unusable. I'm not going to update it, but it remains available here.

Description
------

A simple command line tumblr client to reblog post as is.

It uses Tumblr API v1, so the authentication is not safe at all. Use it for your OWN risk.

	Usage: tumblr.rb [options]
		-e, --email EMAIL                Specified user email
		-p, --password PASSWORD          Specified user password
		-i, --id ID                      Specifies post's id to reblog
		-b, --blog BLOGNAME              Secifies a tumblr blog
		-?, --help                       Show this message

Or you can use the tumblr.conf file:

	email=myemail@example.com
	password=my_super_secret_password_that_will_be_sent_over_http_as_plain_text

example: 

tumblr.rb -i 123 -b mytumblr -p pass
