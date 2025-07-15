<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>About Us</title>

        <!-- ✅ Bootstrap 5 CDN -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/about.css">
        
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="container about-container">
            <h1>About BQT Store</h1>

            <p>Welcome to <span class="highlight">BQT Store</span> – a place for enthusiasts of high-quality model cars!</p>
            <p>We specialize in model cars at scales of <span class="highlight">1:18, 1:24, 1:64</span> from renowned brands such as <span class="highlight">AUTOart, Maisto, Bburago, Minichamps</span>, and many others.</p>
            <p>With over <span class="highlight">5 years of experience</span> in the industry, we always prioritize product quality and customer satisfaction. Each product is thoroughly inspected before reaching the customer.</p>
            <p>Whether you are a professional collector or simply an admirer of the beauty of miniature cars, <span class="highlight">BQT Store</span> always has the right product for you.</p>
            <p>Thank you for your continued trust and support!</p>

            <div class="customer-experience">
                <h2>What We Offer to Our Customers</h2>

                <div class="benefit">
                    <strong>Top-notch product quality:</strong>
                    All model cars are carefully selected, ensuring high accuracy and durability. Providing the best experience with every product.
                </div>

                <div class="benefit">
                    <strong>Diverse product range:</strong>
                    We offer a variety of scales and reputable brands, giving customers many options to suit their preferences and needs. Custom models are also available upon request.
                </div>

                <div class="benefit">
                    <strong>Dedicated consultation service:</strong>
                    Our team is always available 24/7 to assist you in choosing the most suitable product. We provide advice tailored to your passion and interests in cars.
                </div>

                <div class="benefit">
                    <strong>Fast and safe delivery:</strong>
                    Products are carefully packed and quickly shipped to ensure they arrive in perfect condition.
                </div>

                <div class="benefit">
                    <strong>Clear warranty and return policies:</strong>
                    We commit to supporting customers in case of product issues. 12-month warranty from the date of purchase. Returns are accepted within 7 days from the delivery date.
                </div>

                <div class="benefit">
                    <strong>Attractive promotions and discounts:</strong>
                    Regular sales and gift offers for loyal customers with promotions <span class="highlight">up to 300%</span>.
                </div>

                <div class="benefit">
                    <strong>Friendly shopping environment:</strong>
                    Creating a comfortable and secure shopping experience, whether visiting the store or shopping online through social platforms.
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp" />

        <!-- Bootstrap JS (optional) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
