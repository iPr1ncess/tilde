# Create users

# privacy = ["Open", "Members only", "Hidden", "Open"]
#
# ["one", "two", "three", "four"].each_with_index do |x, index|
#   user = User.new(first_name: "User",
#                   last_name: x,
#                   email: "user.#{x}@example.com",
#                   password: "password",
#                   password_confirmation: "password")
#   user.skip_confirmation!
#   user.save!
#   user.profile.privacy_level = Profile.privacy_options[privacy[index]]
#   user.profile.save
# end
# user =
#
#
#
# profile = user.profile
#
# profile.save
#
# user_1 = User.new(first_name: "User",
#                   last_name: "One",
#                   email: "user.one@example.com",
#                   password: "password",
#                   password_confirmation: "password")
#
# user_1.skip_confirmation!
# user_1.save!
#
# profile = user_1.profile
# profile.privacy_level = Profile.privacy_options["Members only"]
# profile.save
#
# user_2 = User.new(first_name: "User",
#                 last_name: "Two",
#                 email: "user.two@example.com",
#                 password: "password",
#                 password_confirmation: "password")
#
# user_2.skip_confirmation!
# user_2.save!
#
# profile = user_2.profile
# profile.privacy_level = Profile.privacy_options["Hidden"]
# profile.save

# Create jobs
# job_params = {
#   title: "Software developer",
#   description: "You should be a kick-ass developer",
#   job_description_location: "http://www.keeward.com",
#   location: "LB",
#   remote_ok: true,
#   posted_on: Time.now,
#   posted_to_slack: false,
#   user_id: user.id,
#   company_name: "Keeward",
#   apply_email: "hr@example.com",
#   salary: nil,
#   job_type: "internship",
#   number_of_openings: 1,
#   level: "no_experience"
# }
#
# job = Job.create(job_params)
# job.post_online!
