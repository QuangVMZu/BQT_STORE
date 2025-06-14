<%@page contentType="text/html" pageEncoding="UTF-8"%>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    footer {
        background-color: #e0f7fa; /* light aqua */
        color: #004d40; /* dark teal */
        padding: 40px 0 0;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .footer-container {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-around;
        max-width: 1200px;
        margin: 0px 150px;
        gap: 100px;
    }

    footer h3 {
        margin-bottom: 20px;
        font-size: 1.5rem;
        color: #00695c; /* dark header */
        border-bottom: 2px solid #80cbc4; /* lighter underline */
        padding-bottom: 8px;
        width: fit-content;
    }

    footer p {
        font-size: 0.95rem;
        color: #004d40;
        margin-bottom: 10px;
        line-height: 1.6;
    }

    .about-description {
        flex: 1 1 300px;
        max-width: 500px;
    }

    .working-hours p {
        margin: 4px 0;
    }

    .bottom-footer {
        margin-top: 40px;
        background-color: #00695c;
        color: #e0f2f1;
        text-align: center;
        padding: 20px 20px;
        font-size: 1rem;
        border-top: 1px solid #00796b;
    }

    .bottom-footer p {
        color: #ffffff;
        margin: 0;
        font-size: 1rem;
    }

    .bottom-footer a {
        color: white;
        text-decoration: none;
        transition: color 0.3s ease;
    }

    .bottom-footer a:hover {
        color: #80cbc4;
    }

    @media (max-width: 768px) {
        .footer-container {
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        footer h3 {
            font-size: 1.3rem;
        }

        footer p {
            font-size: 1.05rem;
        }
    }
</style>

<footer>
    <div class="footer-container">
        <!-- Company description -->
        <div class="about-description">
            <h3><a href="about.jsp" style="color: inherit; text-decoration: none;">BQT STORE</a></h3>
            <p>BQT Store specializes in providing high-quality diecast car models with precise scale and sharp detailing. We offer finely crafted products for collectors, home decoration, or unique gifts – reflecting style, personality, and a deep passion for automobiles.</p>
        </div>

        <!-- Contact information -->
        <div class="contact-info">
            <h3><a href="contact.jsp" style="color: inherit; text-decoration: none;">Contact</a></h3>
            <p>📍 7 D1 Street, Long Thanh My, Thu Duc, Ho Chi Minh City</p>
            <p>✉️ support@vnauto.com</p>
            <p>📞 0123 456 789</p>
        </div>

        <!-- Working hours -->
        <div class="working-hours">
            <h3>Working Hours</h3>
            <p>Monday - Saturday: 8:00 AM - 8:00 PM</p>
            <p>Sunday: 9:00 AM - 6:00 PM</p>
        </div>
    </div>

    <div class="bottom-footer">
        <p>
            &copy; 2025 BQT Store. All rights reserved. &nbsp;&nbsp;|&nbsp;&nbsp; 
            <a href="about.jsp">About us</a> &nbsp;|&nbsp; 
            <a href="contact.jsp">Contact</a>
        </p>
    </div>
</footer>
