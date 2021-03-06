nodemailer = require 'nodemailer'

module.exports = (BasePlugin) ->

	class ContactifyPlugin extends BasePlugin
		name: 'contactify'

		config = docpad.getConfig().plugins.contactify
		smtp = nodemailer.createTransport('SMTP', config.transport)

		serverExtend: (opts) ->
			{server} = opts

			server.post config.path, (req, res) ->
				receivers = []
				enquiry = req.body

				receivers.push(enquiry.email, config.to)

				mailOptions = {
					to: receivers.join(","),
					from: config.from or enquiry.email,
					subject: 'Enquiry from ' + enquiry.name + ' <' + enquiry.email + '>',
					text: enquiry.message,
					html: '<p>' + enquiry.message + '</p>'
				}

				smtp.sendMail mailOptions, (err, resp) ->
					if(err)
						console.log err
					else
						console.log("Message sent: " + resp.message);

				res.redirect enquiry.redirect or config.redirect

			@
