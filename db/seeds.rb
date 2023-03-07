require "json"
require "rest-client"
require "open-uri"
require "nokogiri"

School.destroy_all
Training.destroy_all
Job.destroy_all
Project.destroy_all
Company.destroy_all
User.destroy_all


def xp_calculation(job)
  begin
  date_range = job["dateRange"]
  end_date = date_range.split(" - ")[1].split(" · ")[0]
  end_date = end_date == 'Present' ? Date.today : end_date.to_date
  start_date = date_range.split(" - ")[0].to_date
  (end_date - start_date).fdiv(365.25)
  rescue
    3.5
  end
end

COO_profiles = "app/assets/JSON/coo.json"
file = File.read(COO_profiles)
data = JSON.parse(file)


data.each do |infos|
  user = User.new(
    first_name: infos["general"]["firstName"],
    last_name: infos["general"]["lastName"],
    gender: "female",
    description: infos["general"]["description"],
    mbti: "super smart",
    city: infos["general"]["location"],
    has_a_project: [true, false].sample,
    email: "#{infos["general"]["lastName"]}@gmail.com",
    password: "123456"
  )
  user.save!

  infos["jobs"].first(3).each do |job|
    company1 = Company.new(
      industry: job["companyName"],
    )
    company1.save!

    job_new = Job.new(
      description: job["description"],
      title: job["jobTitle"],
      city: job["location"],
      year_experience: xp_calculation(job)
    )

    job_new.user = user
    job_new.company = company1

    job_new.save!
  end

  schools = infos["schools"]

  schools.each do |dataSchool|

    school = School.find_or_create_by(name: dataSchool["schoolName"])
    training = Training.new(
      title: dataSchool["degree"],
      graduation_year: dataSchool["dateRange"]
    )

    training.user = user
    training.school = school

    training.save

  end
end
#   if user.has_a_project?

#     url = "https://www.indiegogo.com/explore/tech-innovation?project_type=campaign&project_timing=all&sort=trending"

#     html_file = URI.open(url).read
#     html_doc = Nokogiri::HTML.parse(html_file)


#     html_doc.search(".discoverable-card").first(5).each do |element|
#       url = element['href']
#       html_file = URI.open(url).read
#       html_doc = Nokogiri::HTML.parse(html_file)

#       html_doc.search('.body').each do |element|
#         p element.search(".k-Title").text.strip

#       end

#         project = Project.new(
#           name: element.search(".basicsSection-title").text.strip,
#           industry: element.search(".linkedLabelsList-tag").text.strip,
#           pitch_deck: element.search(".class=site-internet").text.strip,
#           pitch: element.search(".basicsSection-tagline").text.strip,
#           city: element.search(".basicsCampaignOwner-details-city").text.strip,
#           user_id: user.id
#         )

#         project.save!
#     end
# end


# /(.*)\s-\s(.*)\s·/.match("Sep 2021 - Jan 2022 · 1 yrs 5 mos")
# matches = _
# matches[1]
# Date.today
