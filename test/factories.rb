FactoryBot.define do
 
  factory :employee do
    first_name { "Ed" }
    last_name { "Gruberman" }
    ssn { rand(9 ** 9).to_s.rjust(9,'0') }
    date_of_birth { 19.years.ago.to_date }
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    role { "employee" }
    active { true }
  end
  
  factory :store do
    name {"CMU"}
    street {"5000 Forbes Avenue"}
    city {"Pittsburgh"}
    state {"PA"}
    zip {"15213"}
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    active {true}
  end
  
  factory :assignment do
    association :store
    association :employee
    start_date {1.year.ago.to_date}
    end_date {1.month.ago.to_date}
    pay_level {1}
  end
  
  factory :shift do
    association :assignment
    date {"2019-09-10"}
    start_time {"12:00:00"}
    end_time {"15:00:00"}
    notes {"good"}
  end
  
  factory :job do
    name { "Security" }
    description {"easy"}
    active { true }
  end

  factory :shift_job do
    association :shift
    association :job
  end
  
  factory :flavor do
    name { "Oreo" }
    active { true }
  end
  
  factory :store_flavor do
    association :store
    association :flavor
  end
  
  factory :user do
    association :employee
    email { "test@gmail.com" }
    password_digest { "qwerty123" }
  end

end
