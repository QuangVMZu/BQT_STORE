<%@ page import="java.util.*" %>
<%
    String user = request.getParameter("user");
    String bot = request.getParameter("bot");

    List<String[]> chatHistory = (List<String[]>) session.getAttribute("chatHistory");
    if (chatHistory == null) {
        chatHistory = new ArrayList<>();
    }
    chatHistory.add(new String[]{"user", user});
    chatHistory.add(new String[]{"bot", bot});
    session.setAttribute("chatHistory", chatHistory);
%>
