# Coaching Conundrum

## Features

### For Coaches
- Create and manage availability slots
- View upcoming booked sessions
- Review past sessions
- Record session notes and satisfaction scores
- Prevent scheduling conflicts with validation

### For Students
- Browse available coaching slots
- Book sessions with preferred coaches
- View upcoming and past sessions
- See feedback and notes from completed sessions

## User Stories Implementation

The application satisfies the following user stories:

### 1. Coaches can add slots of availability to their calendars
- **Implementation**: Coaches can create new availability slots via the "Add Availability" button on the home page.
- **Code Location**: `app/controllers/slots_controller.rb` - `new` and `create` actions
- **Fixed Duration**: All slots are automatically set to 2 hours as defined in the `end_time` method in `app/models/slot.rb`
- **Validation**: Each slot can be booked by exactly 1 student, enforced by the database schema and model associations

### 2. Coaches can view their own upcoming slots
- **Implementation**: Coaches have a dedicated dashboard showing all their upcoming slots
- **Code Location**: `app/views/pages/home.html.erb` - Coach-specific section displays upcoming slots
- **Additional View**: Coaches can also see a more detailed view via "View All Slots" button which links to `app/views/slots/index.html.erb`

### 3. Students can book upcoming, available slots for any coach
- **Implementation**: Students see a list of all available slots from all coaches on their dashboard
- **Code Location**: `app/views/pages/home.html.erb` - Student-specific section shows available slots
- **Booking Process**: Students can book a slot via the "Book Now" button which leads to a confirmation page
- **Backend Logic**: `app/controllers/slots_controller.rb` - `book` and `confirm_booking` actions handle the booking process

### 4. When a slot is booked, both the student and coach can view each other's phone-number
- **Implementation**: Phone numbers are displayed on the dashboard for booked sessions
- **Code Location**: 
  - For coaches: `app/views/pages/home.html.erb` - Shows student phone number in the "Upcoming Booked Sessions" section
  - For students: `app/views/pages/home.html.erb` - Shows coach phone number in the "Your Upcoming Bookings" section
- **Data Model**: Phone numbers are stored in the User model (`app/models/user.rb`)

### 5. After completing a call, coaches record student satisfaction and notes
- **Implementation**: Coaches can record notes and satisfaction scores for past sessions
- **Code Location**: 
  - UI: `app/views/notes/new.html.erb` - Form for recording notes and satisfaction
  - Controller: `app/controllers/notes_controller.rb` - Handles saving the notes and scores
- **Validation**: Satisfaction scores are validated to be integers between 1-5 in `app/models/slot.rb`

### 6. Coaches can review past scores and notes for all calls
- **Implementation**: Coaches can see all past sessions with notes and scores on their dashboard
- **Code Location**: `app/views/pages/home.html.erb` - "Past Sessions" section shows all completed sessions
- **Additional View**: More detailed history available via "Past Sessions" button linking to `app/views/slots/past_sessions.html.erb`
- **Data Display**: Notes are displayed with satisfaction scores (shown as stars) for easy review

## Architecture

The application follows a standard Rails MVC architecture with a focus on clean separation of concerns:

```
coaching_conundrum/
├── app/                      # Application code
│   ├── controllers/          # Request handling logic
│   ├── models/               # Domain models and business logic
│   ├── views/                # UI templates
│   ├── assets/               # Static assets and stylesheets
│   └── javascript/           # Frontend JavaScript
├── config/                   # Application configuration
├── db/                       # Database schema and seeds
├── bin/                      # Executable scripts
└── ...
```

## Installation

### Prerequisites
- Ruby 3.3.2
- PostgreSQL
- Node.js 20.14.0
- Yarn 1.22.22

### Local Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/PritiKumr/stepful.git
   cd coaching_conundrum
   ```

2. Install dependencies:
   ```bash
   bundle install
   yarn install
   ```

3. Setup the database:
   ```bash
   bin/rails db:create db:migrate db:seed
   ```

4. Start the development server:
   ```bash
   rails s
   ```

5. Application runs on `http://localhost:3000` in your browser


### Key Files and Directories

- `app/models/user.rb`: User model with coach/student roles
- `app/models/slot.rb`: Slot model with booking logic and validations
- `app/controllers/slots_controller.rb`: Main controller for slot management
- `app/controllers/notes_controller.rb`: Controller for session notes
- `app/views/pages/home.html.erb`: Main dashboard view
- `db/seeds.rb`: Sample data for development

## Design Decisions

### Authentication System
The application currently uses a simplified authentication system for demonstration purposes, allowing users to switch between accounts via a dropdown. This can be found in the header section of the application. We pass in the user-id as query params to set the user for a request. If no user-id param is passed, we default to first user (regardless of user type).

### Role-Based Access Control
The application implements a straightforward role-based access control system with two roles: coach and student. This is enforced through controller before_actions to ensure proper authorization.

### Data Model
- **User Model**: Represents both coaches and students with a role enum
- **Slot Model**: Central to the application, representing coaching sessions with:
  - Associations to both coach and student
  - Validation to prevent overlapping slots
  - Scopes for filtering (upcoming, past, available)
  - Custom end_time calculation


## Future Enhancements

1. **Authentication & Authorization**:
   - Implement proper user authentication
   - Add more granular permissions

2. **Notifications**:
   - Email/In-app reminders for upcoming sessions
   - SMS notifications

3. **Calendar Integration**:
   - Google Calendar/Outlook integration
   - iCal feed for subscriptions

4. **Proper Data Validations**:
   - Phone numbers and other data do not have validations to them. More elaborate validations can be put in place