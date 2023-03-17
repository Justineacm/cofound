require "json"
require "rest-client"
require "open-uri"
require "nokogiri"

Selection.destroy_all
School.destroy_all
Training.destroy_all
Job.destroy_all
Project.destroy_all
Company.destroy_all
Selection.destroy_all
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
  (end_date(job) - start_date(job)).fdiv(365.25)
end

def end_date(job)
  date_range = job["dateRange"]
  end_date = date_range.split(" - ")[1].nil? ? start_date(job) + 1.month : date_range.split(" - ")[1].split(" · ")[0]
  if end_date.is_a?(String) && end_date.to_i.to_s == end_date
    Date.new(end_date.to_i, 1, 1)
  else
    end_date == 'Present' ? Date.today : end_date.to_date
  end
end

def start_date(job)
  date_range = job["dateRange"]
  p date_range
  if date_range.split(" - ")[0].to_i.to_s == date_range.split(" - ")[0]
    Date.new(date_range.split(" - ")[0].to_i, 1, 1)
  else
    date_range.split(" - ")[0].to_date
  end
end

def kisskissbankbank_scrap
  url = "https://www.kisskissbankbank.com/fr/discover?category=web-and-tech"
  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML.parse(html_file)
  html_doc.search("a.k-ProjectCard")
end

def generate_project(user, index, kisskissprojects)
  return unless user.has_a_project?
  industry = ["AI", "Web3", "cyber", "agrotech", "industry 4.0", "Fintech"]
  city = ["Paris", "Saint-Ouen", "Versailles", "La Défense"]

  element = kisskissprojects[index % kisskissprojects.size]
    url = element['href']
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML.parse(html_file)
    project = Project.new(
      name: html_doc.search("h1.k-Title").text.strip,
      industry: industry.sample,
      city: city.sample,
      user_id: user.id
    )
  puts "creating #{user.first_name} #{user.last_name}'s startup project"
  project.save!
end

COO_profiles = "app/assets/JSON/coo.json"
file = File.read(COO_profiles)
data = JSON.parse(file)
kisskissprojects = kisskissbankbank_scrap

puts "creating COOs"
data.each_with_index do |infos, index|
  user = User.new(
    first_name: infos["general"]["firstName"],
    last_name: infos["general"]["lastName"],
    gender: "female",
    linkedin: infos["general"]["profileUrl"],
    description: infos["general"]["description"],
    mbti: @mbti_profiles.sample,
    mission: [true, false].sample,
    city: infos["general"]["location"],
    photo: infos["general"]["imgUrl"],
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
      industry: job["companyName"]
    )
    company1.save!

    job_new = Job.new(
      description: job["description"],
      title: job["jobTitle"],
      city: job["location"],
      logo: job["logoUrl"],
      start_date: start_date(job),
      end_date: end_date(job),
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

  puts "creating #{user.first_name} #{user.last_name}"
  generate_project(user, index, kisskissprojects)
end

CTO_profiles = "app/assets/JSON/cto.json"

file = File.read(CTO_profiles)
data = JSON.parse(file)
kisskissprojects = kisskissbankbank_scrap

puts "creating CTOs"
data.each_with_index do |infos, index|
  user = User.new(
    first_name: infos["general"]["firstName"],
    last_name: infos["general"]["lastName"],
    gender: "male",
    linkedin: infos["general"]["profileUrl"],
    description: infos["general"]["description"],
    mbti: @mbti_profiles.sample,
    mission: [true, false].sample,
    city: infos["general"]["location"],
    photo: infos["general"]["imgUrl"],
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
      logo: job["logoUrl"],
      start_date: start_date(job),
      end_date: end_date(job),
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

  puts "creating #{user.first_name} #{user.last_name}"
  generate_project(user, index, kisskissprojects)
end

Nico_profile = "app/assets/JSON/NB.json"

file = File.read(Nico_profile)
data = JSON.parse(file)
kisskissprojects = kisskissbankbank_scrap

puts "creating Nico"
data.each_with_index do |infos, index|
  user = User.new(
    first_name: infos["general"]["firstName"],
    last_name: infos["general"]["lastName"],
    gender: "female",
    linkedin: infos["general"]["profileUrl"],
    description: infos["general"]["description"],
    mbti: "Diplomat",
    mission: [true, false].sample,
    city: infos["general"]["location"],
    photo: infos["general"]["imgUrl"],
    has_a_project: false,
    email: "#{infos["general"]["lastName"].strip}@gmail.com",
    password: "123456"
  )
  user.hobby_list.add(@hobbies.sample(2))
  user.personality_list.add(@personality.sample(3))
  user.soft_skill_list.add(@soft_skills.sample(2))
  user.expertise_list.add("Marketing")
  user.language_list.add("French", "English")
  user.save!

  infos["jobs"].first(3).each do |job|
    company1 = Company.new(
      industry: job["companyName"]
    )
    company1.save!

    job_new = Job.new(
      description: job["description"],
      title: job["jobTitle"],
      city: job["location"],
      logo: job["logoUrl"],
      start_date: start_date(job),
      end_date: end_date(job),
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

  puts "creating #{user.first_name} #{user.last_name}"

  saskia_profile = "app/assets/JSON/saskia.json"

  file = File.read(saskia_profile)
  data = JSON.parse(file)
  kisskissprojects = kisskissbankbank_scrap

  puts "creating Saskia"
  data.each_with_index do |infos, index|
    user = User.new(
      first_name: infos["general"]["firstName"],
      last_name: infos["general"]["lastName"],
      gender: "female",
      linkedin: infos["general"]["profileUrl"],
      description: infos["general"]["description"],
      mbti: "Analyst",
      mission: [true, false].sample,
      city: infos["general"]["location"],
      photo: infos["general"]["imgUrl"],
      has_a_project: true,
      email: "#{infos["general"]["lastName"].strip}@gmail.com",
      password: "123456"
    )
    user.hobby_list.add(@hobbies.sample(2))
    user.personality_list.add(@personality.sample(3))
    user.soft_skill_list.add(@soft_skills.sample(2))
    user.expertise_list.add("Technical")
    user.language_list.add("French", "English")
    user.save!

    infos["jobs"].first(3).each do |job|
      company1 = Company.new(
        industry: job["companyName"]
      )
      company1.save!

      job_new = Job.new(
        description: job["description"],
        title: job["jobTitle"],
        city: job["location"],
        logo: job["logoUrl"],
        start_date: start_date(job),
        end_date: end_date(job),
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

    puts "creating #{user.first_name} #{user.last_name}"
end

# /(.*)\s-\s(.*)\s·/.match("Sep 2021 - Jan 2022 · 1 yrs 5 mos")
# matches = _
# matches[1]
# Date.today
end
