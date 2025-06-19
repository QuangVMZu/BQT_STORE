<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Contact Us</title>
        <link rel="stylesheet" href="assets/CSS/contact.css">
    </head>
    <jsp:include page="header.jsp" />
    <body class="contact-page">
        <div class="contact-container">
            <h2 class="contact-title">Contact Us</h2>

            <div class="row">
                <div class="col-half contact-info">
                    <h5>📍 Address</h5>
                    <p>7 D1 Street, Long Thanh My, Thu Duc, Ho Chi Minh City</p>

                    <h5>📞 Phone</h5>
                    <p>+84 123 456 789</p>

                    <h5>✉️ Email</h5>
                    <p>support@vnauto.com</p>

                    <div class="map">
                        <h5>📌 Store Location Map</h5>
                        <iframe 
                            src="https://www.google.com/maps?q=7+Đường+D1,+Long+Thạnh+Mỹ,+Thủ+Đức,+TP.HCM&output=embed" 
                            allowfullscreen="" loading="lazy">
                        </iframe>
                    </div>
                </div>

                <div class="col-half">
                    <form action="sendContact.jsp" method="post">
                        <label for="name" class="form-label">Full Name</label>
                        <input type="text" id="name" name="name" class="form-control" required>

                        <label for="email" class="form-label">Your Email</label>
                        <input type="email" id="email" name="email" class="form-control" required>

                        <label for="message" class="form-label">Message</label>
                        <textarea id="message" name="message" class="form-control" rows="5" required></textarea>

                        <button type="submit" class="btn-submit">Send Message</button>
                    </form>
                </div>
            </div>
        </div>
        <jsp:include page="footer.jsp" />
    </body>
</html>
