// Given a phone number and a password

// When the user enters the phone number
// And the user enters the password
// And the user clicks the submit button

// Then the user sees the homepage
// And the user sees a banner

describe('Logging in', function() {
  it('Successfully logs in', function() {
    const phone_number = 1112223333
    const password = "password1"
    cy.visit('/login')
    cy.get('input[name="phone"]').type(phone_number)
    cy.get('input[name="password"]').type(password)
    cy.contains('Submit').click()
    cy.url().should('match', /\/$/)
    cy.contains('Successfully logged in')
  })
  it('Unsuccessfully logs in', function() {
    const phone_number = 1234567890
    const password = "password1"
    cy.visit('/login')
    cy.get('input[name="phone"]').type(phone_number)
    cy.get('input[name="password"]').type(password)
    cy.contains('Submit').click()
    cy.url().should('match', /login/)
    // cy.contains('Invalid')
  })
})
