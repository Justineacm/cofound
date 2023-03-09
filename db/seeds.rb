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

@hobbies = ["Reading", "Traveling", "Fishing", "Crafting", "Music", "Gardening", "Video Games", "Sport"]
@personality = ["ambitious", "competitive", "motivated", "natural leader", "passionate", "stubborn", "accepting", "casual",
                "charismatic", "easygoing", "relaxed", "social", "critical thinker", "dependable", "detail-oriented", "focused",
                "objective", "logical", "compassionate", "existential", "insightful", "observant", "sensitive", "supportive"]
@soft_skills = ["Teamwork", "Problem solving", "Communication", "Adaptability", "Critical thinking", "Time management", "Interpersonal"]
@expertise = ["Management", "Technical", "Marketing", "Computer"]
@languages = ["Spanish", "English", "German", "Chinese", "Italian"]
@mbti_profiles = ["Analyst", "Diplomat", "Sentinel", "Explorer"]

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

def generate_project(user)
  return unless user.has_a_project?
  url = "https://www.kisskissbankbank.com/fr/discover?category=web-and-tech"
  industry = ["AI", "Web3", "cyber", "agrotech", "industry 4.0", "Fintech"]
  city = ["Paris", "Saint-Ouen", "Versailles", "La Défense"]

  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML.parse(html_file)

  html_doc.search("a.k-ProjectCard").first(10).each do |element|
    url = element['href']
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML.parse(html_file)
    project = Project.new(
      name: html_doc.search("h1.k-Title").text.strip,
      industry: industry.sample,
      city: city.sample,
      user_id: user.id
    )
    puts "generating project"
    project.save!
  end
end


COO_profiles = "app/assets/JSON/coo.json"
file = File.read(COO_profiles)
data = JSON.parse(file)

puts "creating COO"
data.each do |infos|
  user = User.new(
    first_name: infos["general"]["firstName"],
    last_name: infos["general"]["lastName"],
    gender: "female",
    description: infos["general"]["description"],
    mbti: @mbti_profiles.sample,
    mission: [true, false].sample,
    city: infos["general"]["location"],
    has_a_project: [true, false].sample,
    email: "#{infos["general"]["lastName"]}@gmail.com",
    password: "123456"
  )
  user.hobby_list.add(@hobbies.sample(2))
  user.personality_list.add(@personality.sample(3))
  user.soft_skill_list.add(@soft_skills.sample(2))
  user.expertise_list.add(@expertise.sample)
  user.language_list.add("French", @languages.sample)
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

  puts "..."
  generate_project(user)

end

# /(.*)\s-\s(.*)\s·/.match("Sep 2021 - Jan 2022 · 1 yrs 5 mos")
# matches = _
# matches[1]
# Date.today
