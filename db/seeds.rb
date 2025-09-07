# ================================================================
# EVENTBRITE SEEDS - USING .ENV VARIABLES
# ================================================================

require 'dotenv/load' if Rails.env.development?

puts "Cleaning database..."

# Important order to respect dependencies
Payment.destroy_all if defined?(Payment)
Attendance.destroy_all if defined?(Attendance)
Event.destroy_all
User.destroy_all

puts "Database cleaned!"

# ================================================================
# ADMIN USERS CREATION FROM .ENV
# ================================================================

puts "Creating administrators from .env..."

# Check that environment variables exist
required_env_vars = %w[ADMIN_EMAIL ADMIN_PASSWORD ADMIN_FIRST_NAME ADMIN_LAST_NAME]
missing_vars = required_env_vars.select { |var| ENV[var].blank? }

if missing_vars.any?
  puts "Missing environment variables in .env:"
  missing_vars.each { |var| puts "   - #{var}" }
  puts "Creating default admins..."

  # Default admin if .env incomplete
  admin = User.create!(
    first_name: "Default",
    last_name: "Admin",
    email: "admin@eventbrite.local",
    password: "password123",
    password_confirmation: "password123",
    admin: true,
    description: "Default administrator"
  )
else
  # 1. Main admin from .env
  admin = User.create!(
    first_name: ENV['ADMIN_FIRST_NAME'],
    last_name: ENV['ADMIN_LAST_NAME'],
    email: ENV['ADMIN_EMAIL'],
    password: ENV['ADMIN_PASSWORD'],
    password_confirmation: ENV['ADMIN_PASSWORD'],
    admin: true,
    description: "Main administrator configured via .env"
  )

  puts "Main admin created: #{admin.email}"
end

# 2. Secondary admin from .env (if defined)
if ENV['ADMIN2_EMAIL'].present?
  admin2 = User.create!(
    first_name: ENV['ADMIN2_FIRST_NAME'] || 'Admin',
    last_name: ENV['ADMIN2_LAST_NAME'] || 'Secondary',
    email: ENV['ADMIN2_EMAIL'],
    password: ENV['ADMIN2_PASSWORD'] || ENV['ADMIN_PASSWORD'],
    password_confirmation: ENV['ADMIN2_PASSWORD'] || ENV['ADMIN_PASSWORD'],
    admin: true,
    description: "Secondary administrator configured via .env"
  )

  puts "Secondary admin created: #{admin2.email}"
end

# ================================================================
# TEST USERS CREATION
# ================================================================

puts "Creating test users..."

# Event organizers
organisateur1 = User.create!(
  first_name: "Jean",
  last_name: "Martin",
  email: "jean.martin@gmail.com",
  password: "password123",
  password_confirmation: "password123",
  admin: false,
  description: "Organisateur d'événements tech et conférences."
)

organisateur2 = User.create!(
  first_name: "Sophie",
  last_name: "Lemoine",
  email: "sophie.lemoine@outlook.com",
  password: "password123",
  password_confirmation: "password123",
  admin: false,
  description: "Spécialisée dans l'organisation d'événements culturels."
)

organisateur3 = User.create!(
  first_name: "Alexandre",
  last_name: "Petit",
  email: "alex.petit@yahoo.fr",
  password: "password123",
  password_confirmation: "password123",
  admin: false,
  description: "Organisateur d'événements sportifs et de bien-être."
)

# Regular participants
10.times do |i|
  User.create!(
    first_name: "User#{i+1}",
    last_name: "Test",
    email: "user#{i+1}@test.com",
    password: "password123",
    password_confirmation: "password123",
    admin: false,
    description: "Utilisateur de test #{i+1}"
  )
end

puts "✅ #{User.count} utilisateurs créés !"
puts "   - #{User.where(admin: true).count} administrateurs"
puts "   - #{User.where(admin: false).count} utilisateurs normaux"

# ================================================================
# EVENTS CREATION (simplified version)
# ================================================================

puts "🎉 Création des événements..."

# Validated upcoming events
upcoming_events = [
  {
    title: "Hackathon IA & Santé",
    description: "48h pour développer des solutions innovantes alliant IA et Santé.",
    user: organisateur1,
    start_date: 2.weeks.from_now,
    duration: 2880,
    price: 25.0,
    location: "Station F, Paris",
    validated: true,
    validated_by: admin,
    validated_at: 1.week.ago
  },
  {
    title: "Concert Jazz Fusion",
    description: "Soirée jazz avec le quartet 'Fusion Elements'.",
    user: organisateur2,
    start_date: 10.days.from_now,
    duration: 180,
    price: 35.0,
    location: "Le Blue Note, Paris",
    validated: true,
    validated_by: admin,
    validated_at: 4.days.ago
  },
  {
    title: "Formation WordPress Avancée",
    description: "Maîtrisez WordPress comme un pro.",
    user: organisateur1,
    start_date: 3.weeks.from_now,
    duration: 360,
    price: 120.0,
    location: "École du Web, Paris",
    validated: true,
    validated_by: admin,
    validated_at: 1.day.ago
  }
]

# Pending events
pending_events = [
  {
    title: "Conférence Blockchain",
    description: "Découvrez l'avenir de la finance décentralisée.",
    user: organisateur1,
    start_date: 5.weeks.from_now,
    duration: 300,
    price: 75.0,
    location: "Palais des Congrès, Nice",
    validated: nil
  },
  {
    title: "Atelier Cuisine Moléculaire",
    description: "Initiez-vous aux techniques de cuisine moléculaire.",
    user: organisateur2,
    start_date: 6.weeks.from_now,
    duration: 180,
    price: 95.0,
    location: "Institut Culinaire de Lyon",
    validated: nil
  }
]

# Create all events
all_events = upcoming_events + pending_events
all_events.each do |event_data|
  Event.create!(event_data)
end

puts "✅ #{Event.count} événements créés !"

puts "🎫 Création des participations..."

Event.where(validated: true).each do |event|
  participants_count = rand(3..10)
  available_users = User.where(admin: false).where.not(id: event.user.id)
  participants = available_users.sample(participants_count)

  participants.each do |participant|
    # Determine payment_status according to event price
    payment_status = if event.price == 0
      'free'  # Free event
    else
      # 90% chance to be paid, 10% pending
      rand(1..10) <= 9 ? 'succeeded' : 'pending'
    end

    attendance = Attendance.create!(
      user: participant,
      event: event,
      payment_status: payment_status,
      amount_paid: event.price > 0 ? (event.price * 100).to_i : 0, # En centimes
      created_at: rand(1.week.ago..Time.current)
    )

    # Create payment if necessary
    if event.price > 0 && payment_status == 'succeeded'
      Payment.create!(
        user: attendance.user,
        event: event,
        attendance: attendance,
        amount: (event.price * 100).to_i, # En centimes
        status: 'succeeded',
        stripe_checkout_session_id: "cs_test_#{SecureRandom.hex(12)}",
        stripe_payment_intent_id: "pi_test_#{SecureRandom.hex(8)}",
        created_at: attendance.created_at
      )
    end
  end
end

puts "✅ #{Attendance.count} participations créées !"
puts "   - #{Attendance.where(payment_status: [ 'succeeded', 'free' ]).count} confirmées"
puts "   - #{Attendance.where(payment_status: 'pending').count} en attente"



puts "\n" + "="*60
puts "🎉 SEEDS TERMINÉS AVEC SUCCÈS !"
puts "="*60

puts "\nSTATISTICS:"
puts "   Users: #{User.count}"
puts "   Events: #{Event.count}"
puts "   Attendances: #{Attendance.count}"

puts "\nADMIN ACCOUNTS (from .env):"
User.where(admin: true).each do |admin_user|
  puts "   Email: #{admin_user.email}"
  puts "   Name: #{admin_user.full_name}"
end
puts "   Password: #{ENV['ADMIN_PASSWORD'] || 'password123'}"
puts "   URL: #{ENV['APP_URL'] || 'http://localhost:3000'}/admin/login"

puts "\nYour application is ready!"
puts "="*60
