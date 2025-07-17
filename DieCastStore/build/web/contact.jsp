<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Contact Us</title>

        <!-- ✅ Bootstrap 5 CDN -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <link rel="stylesheet" href="assets/css/contact.css">
    </head>

    <body>
        <jsp:include page="header.jsp" />

        <div class="container contact-container">
            <h2 class="contact-title">Contact Us</h2>
            <div class="row">
                <!-- Contact Info -->
                <div class="col-md-6 contact-info">
                    <h5>📍 Address</h5>
                    <p>7 D1 Street, Long Thanh My, Thu Duc, Ho Chi Minh City</p>

                    <h5>📞 Phone</h5>
                    <p>+84 123 456 789</p>

                    <h5>✉️ Email</h5>
                    <p>support_bqtstore@gmail.com</p>

                    <div class="map">
                        <h5>📌 Store Location Map</h5>
                        <iframe 
                            src="https://www.google.com/maps?q=7+Đường+D1,+Long+Thạnh+Mỹ,+Thủ+Đức,+TP.HCM&output=embed"
                            allowfullscreen="" loading="lazy">
                        </iframe>
                    </div>
                </div>

                <!-- Contact Form -->
                <div class="col-md-6">
                    <form action="MainController" method="post" accept-charset="UTF-8">
                        <input type="hidden" name="action" value="sentContact" />

                        <div class="mb-3">
                            <label for="name" class="form-label">Full Name</label>
                            <input type="text" id="name" name="name" class="form-control" required />
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Your Email</label>
                            <input type="email" id="email" name="email" class="form-control" required />
                        </div>

                        <div class="mb-3">
                            <label for="message" class="form-label">Message</label>
                            <textarea id="message" name="message" class="form-control" rows="5" required></textarea>
                        </div>

                        <button type="submit" class="btn-submit w-100">Send Message</button>
                    </form>
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp" />
        <!-- Optional Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
