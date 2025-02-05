const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

// Initialize Firebase Admin SDK
admin.initializeApp();

// Configure your email provider (Gmail SMTP example)
const transporter = nodemailer.createTransport({
  service: "gmail", // Use a recognized email service provider
  auth: {
    user: process.env.EMAIL_USER, // Use environment variables for security
    pass: process.env.EMAIL_PASS, // Use environment variables for security
  },
});

// Cloud Function to send a welcome email
exports.sendWelcomeEmail = functions.https.onCall((data, context) => {
  const email = data.email;

  const mailOptions = {
    from: "hire4consult@gmail.com", // Your app's email
    to: email,
    subject: "Welcome to Hire4Consult!",
    text: `Hello, ${email}!\n\nWelcome to Hire4Consult. We are excited to have you onboard! 🎉\n\nBest Regards,\nHire4Consult Team`,
  };

  return transporter.sendMail(mailOptions)
    .then(() => {
      return { message: "Welcome email sent successfully!" };
    })
    .catch((error) => {
      console.error("Error sending email:", error);
      throw new functions.https.HttpsError("internal", "Error sending email", error);
    });
});
