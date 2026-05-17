<%@ Page Title="Home" Language="vb" AutoEventWireup="false" MasterPageFile="~/Customers/Customer.Master"
    CodeBehind="Home.aspx.vb" Inherits="Cloud_Kitchen.WebForm1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --primary:   #4F7E76;
            --primary-dk:#3a5f59;
            --accent:    #ff9f43;
            --accent-dk: #e8872a;
            --bg:        #fafafa;
            --sc:        #f4f4f4;
            --txt:       #333;
            --card-bg:   #fff;
        }

        html { scroll-behavior: smooth; }

        body {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background: var(--bg);
            color: var(--txt);
        }

        .section-title {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            font-size: clamp(1.7rem, 4vw, 2.4rem);
            color: var(--primary);
            position: relative;
            display: inline-block;
            padding-bottom: .55rem;
            margin-bottom: 2.5rem;
        }
        .section-title::after {
            content: '';
            position: absolute;
            bottom: 0; left: 50%; transform: translateX(-50%);
            width: 60px; height: 4px;
            background: var(--accent);
            border-radius: 2px;
        }

        .ck-hero {
            position: relative;
            min-height: 100vh;
            background: linear-gradient(rgba(0,0,0,.55), rgba(0,0,0,.55)),
                        url('../Images/lb6.jpeg') center/cover no-repeat;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 100px 20px 80px;
            color: #fff;
            animation: heroFadeIn 1s ease-out both;
        }

        @keyframes heroFadeIn {
            from { opacity: 0; }
            to   { opacity: 1; }
        }

        .ck-hero h1 {
           font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            font-size: clamp(2rem, 6vw, 3.5rem);
            font-weight: 700;
            text-shadow: 0 2px 20px rgba(0,0,0,.5);
            animation: slideUp .9s .2s ease both;
        }

        .ck-hero p.lead {
            font-size: clamp(1rem, 2.5vw, 1.2rem);
            max-width: 560px;
            opacity: .9;
            animation: slideUp .9s .35s ease both;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }


.hero-search {
    width: 100%;
    max-width: 620px;
    position: relative;
    margin-top: 15px;
    animation: slideUp .9s .5s ease both;
}

.search-glass {
    position: relative;
    display: flex;
    align-items: center;
    background: rgba(255,255,255,0.12);
    backdrop-filter: blur(18px);
    -webkit-backdrop-filter: blur(18px);

    border: 1px solid rgba(255,255,255,0.18);

    border-radius: 70px;

    padding: 8px;

    box-shadow:
        0 10px 40px rgba(0,0,0,.25),
        inset 0 1px 0 rgba(255,255,255,.12);

    overflow: hidden;

    transition: all .35s ease;
}

.search-glass:hover {
    transform: translateY(-2px);
    box-shadow:
        0 16px 45px rgba(0,0,0,.35),
        inset 0 1px 0 rgba(255,255,255,.15);
}

.search-glass:focus-within {
    border-color: rgba(255,255,255,.35);
    box-shadow:
        0 0 0 4px rgba(255,159,67,.18),
        0 15px 50px rgba(0,0,0,.35);
}

.search-icon {
    width: 48px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: rgba(255,255,255,.88);
    font-size: 1.2rem;
    flex-shrink: 0;
}

.search-input {
    flex: 1;
    background: transparent;
    border: none;
    outline: none;

    color: white;

    font-size: 1rem;
    font-weight: 500;

    padding: 14px 8px;

    min-width: 0;
}

.search-input::placeholder {
    color: rgba(255,255,255,.72);
    font-weight: 400;
}

.search-btn {
    border: none;

    background: linear-gradient(135deg, #ff9f43, #ff7b00);

    color: white;

    font-weight: 600;
    font-size: .95rem;

    padding: 14px 24px;

    border-radius: 50px;

    cursor: pointer;

    transition: all .3s ease;

    white-space: nowrap;

    box-shadow:
        0 6px 20px rgba(255,123,0,.35);

    flex-shrink: 0;
}

.search-btn:hover {
    transform: translateY(-2px) scale(1.03);

    background: linear-gradient(135deg, #ffb25c, #ff8a14);

    box-shadow:
        0 10px 28px rgba(255,123,0,.45);
}

.search-btn:active {
    transform: scale(.96);
}

.suggestions {
    position: absolute;
    top: calc(100% + 12px);
    left: 0;
    right: 0;

    background: rgba(20,20,20,.82);

    backdrop-filter: blur(18px);
    -webkit-backdrop-filter: blur(18px);

    border-radius: 18px;

    overflow: hidden;

    z-index: 9999;

    box-shadow: 0 20px 40px rgba(0,0,0,.35);

    border: 1px solid rgba(255,255,255,.08);
}

.suggestions p {
    margin: 0;
    padding: 14px 20px;

    color: white;

    cursor: pointer;

    transition: all .25s ease;

    font-size: .95rem;
}

.suggestions p:hover {
    background: rgba(255,255,255,.1);
    padding-left: 26px;
}


@media (max-width: 576px) {

    .hero-search {
        max-width: 100%;
    }

    .search-glass {
        padding: 6px;
    }

    .search-input {
        font-size: .92rem;
        padding: 12px 6px;
    }

    .search-btn {
        padding: 12px 18px;
        font-size: .88rem;
    }

    .search-icon {
        width: 42px;
        font-size: 1rem;
    }
}
        .scroll-cue {
            position: absolute;
            bottom: 28px;
            left: 50%;
            transform: translateX(-50%);
            color: rgba(255,255,255,.55);
            font-size: 1.6rem;
            animation: bounce 2s infinite;
        }
        @keyframes bounce {
            0%,100% { transform: translateX(-50%) translateY(0); }
            50%      { transform: translateX(-50%) translateY(8px); }
        }

        .featured-section {
            background: var(--sc);
            padding: 80px 0;
        }

        .dish-card {
            background: var(--card-bg);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,.08);
            transition: transform .3s, box-shadow .3s;
            height: 100%;
        }
        .dish-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 12px 36px rgba(0,0,0,.14);
        }

        .dish-card img {
            width: 100%;
            height: 220px;
            object-fit: cover;
            border-bottom: 4px solid var(--primary);
            transition: transform .4s;
        }
        .dish-card:hover img { transform: scale(1.04); }

        .dish-card .card-body { padding: 1.2rem 1.4rem; }
        .dish-card .card-body h5 {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            color: var(--primary);
            margin-bottom: .4rem;
        }
        .dish-card .card-body p { font-size: .9rem; color: #666; margin: 0; }

.about-section {
    padding: 110px 0;
    position: relative;
    background:
        radial-gradient(circle at top left,
        rgba(79,126,118,0.12),
        transparent 32rem),
        linear-gradient(180deg,#ffffff 0%,#f8fafc 100%);
}



.about-badge{
    display:inline-flex;
    align-items:center;
    gap:8px;
    padding:10px 18px;
    border-radius:999px;
    background:rgba(255,159,67,0.12);
    color:#ff9f43;
    font-weight:700;
    font-size:.9rem;
}

.about-heading{
    margin-top:24px;
    font-size:clamp(2.2rem,5vw,4rem);
    font-weight:800;
    line-height:1.1;
    color:#0f172a;
}

.about-heading span{
    display:block;
    color:var(--ck-primary);
}

.about-subheading{
    max-width:800px;
    margin-top:20px;
    font-size:1.05rem;
    line-height:1.9;
    color:#64748b;
}



.about-image-wrapper{
    position:relative;
}

.img-slide{
    position:relative;
    width:100%;
    height:550px;
    border-radius:32px;
    overflow:hidden;
    box-shadow:0 28px 70px rgba(0,0,0,.18);
}

.slide-img{
    position:absolute;
    inset:0;
    width:100%;
    height:100%;
    object-fit:cover;
    opacity:0;
    transition:opacity 1.2s ease;
}

.slide-img.active{
    opacity:1;
}



.about-floating-card{
    position:absolute;
    display:flex;
    align-items:center;
    gap:14px;
    padding:16px 18px;
    border-radius:20px;
    background:rgba(255,255,255,0.92);
    backdrop-filter:blur(12px);
    box-shadow:0 14px 40px rgba(0,0,0,.12);
    border:1px solid rgba(255,255,255,0.6);
    min-width:240px;
}

.about-floating-card i{
    width:56px;
    height:56px;
    border-radius:18px;
    display:flex;
    align-items:center;
    justify-content:center;
    background:linear-gradient(135deg,#ff9f43,#ff7b00);
    color:#fff;
    font-size:1.35rem;
    flex-shrink:0;
}

.about-floating-card strong{
    display:block;
    color:#0f172a;
    font-size:1rem;
    font-weight:800;
}

.about-floating-card span{
    color:#64748b;
    font-size:.9rem;
}

.card-one{
    top:30px;
    left:-24px;
}

.card-two{
    bottom:30px;
    right:-24px;
}



.about-content-box{
    padding-left:24px;
}

.about-mini-title{
    display:inline-flex;
    align-items:center;
    gap:8px;
    color:#ff9f43;
    font-weight:700;
    margin-bottom:18px;
}

.about-title{
    font-size:clamp(1.9rem,4vw,3rem);
    font-weight:800;
    line-height:1.2;
    color:#0f172a;
    margin-bottom:22px;
}

.about-description{
    color:#5f6b7a;
    font-size:1rem;
    line-height:2;
    text-align:justify;
    margin-bottom:20px;
}



.about-feature-card{
    display:flex;
    align-items:center;
    gap:14px;
    padding:18px;
    background:#fff;
    border-radius:18px;
    border:1px solid rgba(0,0,0,.05);
    box-shadow:0 10px 28px rgba(0,0,0,.05);
    transition:.3s ease;
    font-weight:700;
    color:#0f172a;
}

.about-feature-card:hover{
    transform:translateY(-5px);
    box-shadow:0 18px 40px rgba(0,0,0,.1);
    cursor:pointer;
}

.about-feature-card i{
    width:48px;
    height:48px;
    border-radius:14px;
    display:flex;
    align-items:center;
    justify-content:center;
    background:rgba(79,126,118,0.12);
    color:var(--ck-primary);
    font-size:1.2rem;
}



.about-btn{
    display:inline-flex;
    align-items:center;
    gap:10px;
    padding:15px 28px;
    border-radius:999px;
    background:linear-gradient(135deg,#ff9f43,#ff7b00);
    color:#fff;
    text-decoration:none;
    font-weight:700;
    box-shadow:0 14px 35px rgba(255,159,67,.28);
    transition:.3s ease;
}

.about-btn:hover{
    transform:translateY(-3px);
    color:#fff;
    box-shadow:0 20px 45px rgba(255,159,67,.35);
}



@media(max-width:991px){

    .about-content-box{
        padding-left:0;
    }

    .card-one{
        left:10px;
    }

    .card-two{
        right:10px;
    }
}

@media(max-width:575px){

    .about-section{
        padding:80px 0;
    }

    .img-slide{
        height:320px;
        border-radius:24px;
    }

    .about-heading{
        font-size:2.3rem;
    }

    .about-title{
        font-size:2rem;
    }

    .about-description{
        text-align:left;
        line-height:1.9;
    }

    .about-floating-card{
        min-width:auto;
        width:calc(100% - 30px);
        padding:12px 14px;
    }

    .about-floating-card i{
        width:48px;
        height:48px;
        border-radius:14px;
    }

    .about-feature-card{
        padding:16px;
    }

    .about-btn{
        width:100%;
        justify-content:center;
    }
}

        .testimonials-section {
            background: var(--sc);
            padding: 80px 0;
        }

        .testimonial-wrap {
            max-width: 680px;
            margin: 0 auto;
        }

        .message-card {
            background: #fff;
            border-radius: 20px;
            padding: 2rem 2.5rem;
            box-shadow: 0 8px 30px rgba(0,0,0,.09);
            position: relative;
            min-height: 160px;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            gap: .6rem;
        }

        .message-card .quote-icon {
            font-size: 2.5rem;
            color: var(--accent);
            line-height: 1;
        }

        .message-item { display: none; }
        .message-item.active { display: flex; flex-direction: column; align-items: center; }

        .avatar-circle {
            width: 54px; height: 54px;
            border-radius: 50%;
            background: var(--primary);
            color: #fff;
            font-size: 1.4rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: .4rem;
        }

        .message-name { font-weight: 600; color: var(--primary); font-size: 1rem; }
        .message-text { color: #555; font-size: .95rem; line-height: 1.65; }

        .progress-bar-wrap {
            height: 4px;
            background: #e2e2e2;
            border-radius: 4px;
            margin-top: 1.4rem;
            overflow: hidden;
        }
        .progress-bar-ck {
            height: 100%;
            background: var(--accent);
            width: 0;
            transition: width 4.5s linear;
        }

.contact-section {
    position: relative;
    padding: 110px 0;
    overflow: hidden;
    background:
        radial-gradient(circle at top left, rgba(79,126,118,.08), transparent 28rem),
        radial-gradient(circle at bottom right, rgba(255,159,67,.10), transparent 24rem),
        linear-gradient(180deg, #fffdf8 0%, #f8f6f1 100%);
}

.contact-section::before {
    content: '';
    position: absolute;
    inset: 0;
    background-image:
        linear-gradient(rgba(0,0,0,.02) 1px, transparent 1px),
        linear-gradient(90deg, rgba(0,0,0,.02) 1px, transparent 1px);
    background-size: 38px 38px;
    pointer-events: none;
}

.contact-wrapper {
    position: relative;
    z-index: 2;
}

.contact-card {
    position: relative;
    background: rgba(255,255,255,.92);
    backdrop-filter: blur(16px);
    border: 1px solid rgba(255,255,255,.7);
    border-radius: 28px;
    box-shadow:
        0 18px 45px rgba(0,0,0,.08),
        0 6px 18px rgba(0,0,0,.04);
    padding: 2.6rem;
    overflow: hidden;
    transition: transform .35s ease, box-shadow .35s ease;
}

.contact-card:hover {
    transform: translateY(-6px);
    box-shadow:
        0 24px 60px rgba(0,0,0,.12),
        0 10px 24px rgba(0,0,0,.06);
}

.contact-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 5px;
    background: linear-gradient(90deg,var(--primary),var(--accent));
}

.contact-subtitle {
    color: #6b7280;
    font-size: .98rem;
    line-height: 1.8;
    margin-bottom: 2rem;
}

/* FORM */
.form-group-modern {
    position: relative;
}

.form-group-modern i {
    position: absolute;
    top: 50%;
    left: 18px;
    transform: translateY(-50%);
    color: #9ca3af;
    font-size: 1rem;
    z-index: 2;
}

.form-group-modern textarea + i {
    top: 24px;
    transform: none;
}

.ck-input {
    width: 100%;
    padding: 14px 18px 14px 50px;
    border: 1.5px solid #e5e7eb;
    border-radius: 16px;
    background: #fcfcfc;
    font-family: 'Poppins', sans-serif;
    font-size: .95rem;
    color: #111827;
    transition: all .3s ease;
    outline: none;
    resize: none;
}

.ck-input::placeholder {
    color: #9ca3af;
}

.ck-input:focus {
    border-color: var(--accent);
    background: #fff;
    box-shadow: 0 0 0 5px rgba(255,159,67,.14);
}

.ck-input:focus + i {
    color: var(--accent);
}

.ck-submit-btn {
    border: none;
    border-radius: 999px;
    padding: 14px 30px;
    background: linear-gradient(135deg,var(--primary),var(--primary-dk));
    color: #fff;
    font-weight: 700;
    font-size: .95rem;
    letter-spacing: .3px;
    display: inline-flex;
    align-items: center;
    gap: 10px;
    transition: all .3s ease;
    box-shadow: 0 12px 28px rgba(79,126,118,.22);
}

.ck-submit-btn:hover {
    transform: translateY(-3px);
    background: linear-gradient(135deg,var(--accent),#ff8c1a);
    box-shadow: 0 18px 34px rgba(255,159,67,.28);
}

.contact-info-box {
    position: relative;
    height: 100%;
    background:
        linear-gradient(135deg, rgba(79,126,118,.96), rgba(30,41,59,.96));
    border-radius: 28px;
    padding: 2.7rem;
    color: #fff;
    overflow: hidden;
    box-shadow: 0 20px 55px rgba(0,0,0,.16);
}

.contact-info-box::before {
    content: '';
    position: absolute;
    width: 280px;
    height: 280px;
    background: rgba(255,255,255,.05);
    border-radius: 50%;
    top: -100px;
    right: -100px;
}

.contact-info-box::after {
    content: '';
    position: absolute;
    width: 180px;
    height: 180px;
    background: rgba(255,159,67,.12);
    border-radius: 50%;
    bottom: -60px;
    left: -60px;
}

.contact-info-title {
    font-size: 2rem;
    font-weight: 800;
    margin-bottom: .8rem;
    position: relative;
    z-index: 2;
}

.contact-info-text {
    color: rgba(255,255,255,.78);
    line-height: 1.9;
    margin-bottom: 2rem;
    position: relative;
    z-index: 2;
}

.contact-info-item {
    position: relative;
    z-index: 2;
    display: flex;
    align-items: flex-start;
    gap: 16px;
    margin-bottom: 1.5rem;
}


.contact-icon {
    width: 52px;
    height: 52px;
    min-width: 52px;
    border-radius: 16px;

    background: linear-gradient(135deg, #ff9f43, #ff7b00);

    color: #ffffff;

    display: flex;
    align-items: center;
    justify-content: center;

    font-size: 1.15rem;

    box-shadow: 0 10px 24px rgba(255, 159, 67, 0.28);

    transition: all .3s ease;
}

.contact-info-item:hover .contact-icon {
    transform: translateY(-4px) scale(1.05);

    background: linear-gradient(135deg, #4F7E76, #31544e);

    box-shadow: 0 14px 28px rgba(79, 126, 118, 0.28);
    cursor:pointer;
}
.contact-info-item h6 {
    margin: 0 0 4px;
    font-size: .95rem;
    font-weight: 700;
    color: #fff;
}

.contact-info-item p,
.contact-info-item a {
    margin: 0;
    color: rgba(255,255,255,.78);
    text-decoration: none;
    line-height: 1.7;
    transition: color .25s ease;
}

.contact-info-item a:hover {
    color: var(--accent);
}

.contact-social {
    position: relative;
    z-index: 2;
    display: flex;
    gap: 12px;
    margin-top: 2rem;
}

.contact-social a {
    width: 44px;
    height: 44px;
    border-radius: 14px;
    background: rgba(255,255,255,.10);
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all .3s ease;
    text-decoration: none;
    border: 1px solid rgba(255,255,255,.08);
}

.contact-social a:hover {
    background: var(--accent);
    transform: translateY(-4px);
    
}

.error-message {
    font-size: .82rem;
    padding-left: 4px;
}

@keyframes ck-reveal {
    from {
        opacity: 0;
        transform: translateY(35px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.reveal {
    animation: ck-reveal linear;
    animation-timeline: view();
    animation-range: entry 0% cover 34%;
}

@media (max-width: 991px) {
    .contact-section {
        padding: 85px 0;
    }

    .contact-card,
    .contact-info-box {
        padding: 2rem;
    }
}

@media (max-width: 576px) {

    .contact-card,
    .contact-info-box {
        border-radius: 22px;
        padding: 1.6rem;
    }

    .contact-info-title {
        font-size: 1.7rem;
    }

    .ck-submit-btn {
        width: 100%;
        justify-content: center;
    }
}
    </style>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <section class="ck-hero">
        <h1 class="mb-3">
            Welcome to Cloud Kitchen
            <% 
                If Session("c_name") IsNot Nothing Then
                    Response.Write(" " & Session("c_name"))
                End If
            %>
        </h1>
        <p class="lead mb-4">Delicious food delivered right to your door, with love and freshness!</p>

<div class="hero-search">

    <div class="search-glass">

        <div class="search-icon">
            <i class="bi bi-search"></i>
        </div>

        <input type="text"
            id="searchBar"
            class="search-input"
            placeholder="Search delicious dishes..."
            autocomplete="off" />

        <asp:Button ID="btnSearch"
            runat="server"
            CssClass="search-btn"
            Text="Search"
            OnClientClick="saveSearchValue(); return true;"
            OnClick="btnSearch_Click" />

    </div>

    <asp:HiddenField ID="hiddenSearch" runat="server" />

    <div id="suggestions" class="suggestions"></div>

</div>

        <span class="scroll-cue">⌄</span>
    </section>

    <asp:Repeater ID="rptFeatured" runat="server">
        <HeaderTemplate>
            <section class="featured-section">
                <div class="container">
                    <div class="text-center">
                        <h2 class="section-title">Featured Dishes</h2>
                    </div>
                    <div class="row g-4 justify-content-center">
        </HeaderTemplate>
        <ItemTemplate>
            <div class="col-12 col-sm-6 col-lg-4 reveal">
                <div class="dish-card">
                    <a href="Menu.aspx">
                        <img src='<%# Eval("m_image_url") %>' alt='<%# Eval("m_name") %>' />
                    </a>
                    <div class="card-body">
                        <h5><%# Eval("m_name") %></h5>
                        <p><%# Eval("m_description") %></p>
                    </div>
                </div>
            </div>
        </ItemTemplate>
        <FooterTemplate>
                    </div>
                </div>
            </section>
        </FooterTemplate>
    </asp:Repeater>

   <section class="about-section position-relative overflow-hidden" id="about">
    <div class="container">

        <div class="text-center mb-5 reveal">

            <span class="about-badge">
                <i class="bi bi-stars"></i>
                About Cloud Kitchen
            </span>

            <h2 class="about-heading">
                Crafted With Passion,
                <span>Served With Love</span>
            </h2>

            <p class="about-subheading mx-auto">
                Bringing restaurant-quality meals directly to your doorstep with
                freshness, hygiene, and unforgettable taste.
            </p>
        </div>

        <div class="row align-items-center g-5">

            <div class="col-lg-6 reveal">

                <div class="about-image-wrapper">

                    <div class="img-slide" id="slider">

                        <img src="../Images/hero-bg.jpg" class="slide-img active" alt="food" />
                        <img src="../Images/hero-bg1.jpg" class="slide-img" alt="food" />
                        <img src="../Images/img3.jpg" class="slide-img" alt="food" />
                        <img src="../Images/img5.jpg" class="slide-img" alt="food" />
                        <img src="../Images/s1.jpeg" class="slide-img" alt="food" />
                        <img src="../Images/s2.jpeg" class="slide-img" alt="food" />
                        <img src="../Images/gallery-2.jpg" class="slide-img" alt="food" />
                        <img src="../Images/gallery-3.jpg" class="slide-img" alt="food" />
                        <img src="../Images/gallery-4.jpg" class="slide-img" alt="food" />

                    </div>

                    <div class="about-floating-card card-one">
                        <i class="bi bi-clock-history"></i>

                        <div>
                            <strong>Fast Delivery</strong>
                            <span>Delivered within 30 mins</span>
                        </div>
                    </div>

                    <div class="about-floating-card card-two">
                        <i class="bi bi-shield-check"></i>

                        <div>
                            <strong>Fresh & Hygienic</strong>
                            <span>Premium quality ingredients</span>
                        </div>
                    </div>

                </div>

            </div>

            <div class="col-lg-6 reveal">

                <div class="about-content-box">

                    <div class="about-mini-title">
                        <i class="bi bi-fire"></i>
                        Why Choose Us
                    </div>

                    <h3 class="about-title">
                        Fresh meals made daily with premium ingredients.
                    </h3>

                    <p class="about-description">
                        At Cloud Kitchen, we are passionate about crafting delightful meals
                        that bring joy to your taste buds and warmth to your heart.
                        Our journey began with a simple vision — serving delicious,
                        hygienic, and high-quality food conveniently delivered to your doorstep.
                    </p>

                    <p class="about-description">
                        Every dish is thoughtfully prepared using hand-picked ingredients,
                        chef-crafted recipes, and modern hygiene standards to ensure
                        a flavorful and memorable dining experience every single time.
                    </p>



                    <div class="mt-5">

                        <a href="Menu.aspx" class="about-btn">
                            Explore Menu
                            <i class="bi bi-arrow-right"></i>
                        </a>

                    </div>

                </div>
</div>
                  <div class="row g-3 mt-4">

                        <div class="col-6">
                            <div class="about-feature-card">
                                <i class="bi bi-truck"></i>
                                <span>Quick Delivery</span>
                            </div>
                        </div>

                        <div class="col-6">
                            <div class="about-feature-card">
                                <i class="bi bi-award"></i>
                                <span>Premium Quality</span>
                            </div>
                        </div>

                        <div class="col-6">
                            <div class="about-feature-card">
                                <i class="bi bi-heart"></i>
                                <span>Made With Love</span>
                            </div>
                        </div>

                        <div class="col-6">
                            <div class="about-feature-card">
                                <i class="bi bi-cup-hot"></i>
                                <span>Fresh Everyday</span>
                            </div>
                        </div>

                    </div>

            

        </div>
    </div>
</section>
    <section class="testimonials-section">
        <div class="container">
            <div class="text-center">
                <h2 class="section-title">What Our Customers Say</h2>
            </div>

            <div class="testimonial-wrap reveal">
                <div class="message-card">
                    <div class="quote-icon">"</div>
                    <asp:Repeater ID="rptReadMessages" runat="server">
                        <ItemTemplate>
                            <div class="message-item">
                                <div class="avatar-circle">
                                    <%# Eval("name").ToString().Substring(0,1).ToUpper() %>
                                </div>
                                <div class="message-name"><%# Eval("name") %></div>
                                <div class="message-text"><%# Eval("message") %></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <div class="progress-bar-wrap">
                    <div class="progress-bar-ck" id="testimonialBar"></div>
                </div>
            </div>
        </div>
    </section>
<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

<asp:UpdatePanel ID="UpdatePanel2" runat="server">
    <ContentTemplate>

        <section class="contact-section">
            <div class="container contact-wrapper">

                <div class="text-center mb-5 reveal">
                    <h2 class="section-title">Contact & Feedback</h2>
                    <p class="section-subtitle mx-auto">
                        Have a question, suggestion, or feedback? We’d love to hear from you.
                        Reach out anytime and our Cloud Kitchen team will assist you quickly.
                    </p>
                </div>

                <div class="row g-4 align-items-stretch">

                    <div class="col-lg-7 reveal">
                        <div class="contact-card h-100">

                            <h4 class="fw-bold mb-2" style="color:var(--primary);">
                                Send us a Message
                            </h4>

                            <p class="contact-subtitle">
                                Share your experience, suggestions, or any issue related to your order.
                            </p>

                            <div class="d-flex flex-column gap-3">

                                <div class="form-group-modern">
                                    <asp:TextBox ID="txtName" runat="server"
                                        placeholder="Your Full Name"
                                        CssClass="ck-input"
                                        ReadOnly="true"></asp:TextBox>
                                    <i class="bi bi-person"></i>
                                </div>

                                <div class="form-group-modern">
                                    <asp:TextBox ID="txtEmail" runat="server"
                                        placeholder="Your Email Address"
                                        CssClass="ck-input"
                                        ReadOnly="true"></asp:TextBox>
                                    <i class="bi bi-envelope"></i>
                                </div>

                                <div class="form-group-modern">
                                    <asp:TextBox ID="txtMessage" runat="server"
                                        placeholder="Write your message here..."
                                        TextMode="MultiLine"
                                        Rows="6"
                                        CssClass="ck-input"></asp:TextBox>
                                    <i class="bi bi-chat-dots"></i>
                                </div>

                                <asp:RequiredFieldValidator ID="rfvMessage" runat="server"
                                    ControlToValidate="txtMessage"
                                    ErrorMessage="Please enter your message."
                                    CssClass="error-message text-danger"
                                    Display="Dynamic" />

                                <asp:Label ID="Label1" runat="server"
                                    Font-Bold="True"
                                    ForeColor="#4F7E76"></asp:Label>

                                <div class="pt-2">
                                    <asp:Button ID="btnSubmit"
                                        runat="server"
                                        Text="Send Feedback"
                                        CssClass="ck-submit-btn" />
                                </div>

                            </div>
                        </div>
                    </div>

                    <div class="col-lg-5 reveal">
                        <div class="contact-info-box">

                            <h3 class="contact-info-title">
                                Let’s Connect
                            </h3>

                            <p class="contact-info-text">
                                We’re here to help with orders, support, or partnership inquiries.
                                Reach out through any of the channels below.
                            </p>

                            <div class="contact-info-item">
                                <div class="contact-icon">
                                    <i class="bi bi-geo-alt-fill"></i>
                                </div>
                                <div>
                                    <h6>Our Location</h6>
                                    <p>Vidhyanagar, Anand, Gujarat</p>
                                </div>
                            </div>

                            <div class="contact-info-item">
                                <div class="contact-icon">
                                    <i class="bi bi-telephone-fill"></i>
                                </div>
                                <div>
                                    <h6>Phone Number</h6>
                                    <a href="tel:8160698196">+91 8160698196</a>
                                </div>
                            </div>

                            <div class="contact-info-item">
                                <div class="contact-icon">
                                    <i class="bi bi-envelope-fill"></i>
                                </div>
                                <div>
                                    <h6>Email Address</h6>
                                    <a href="mailto:info.cloudkitchenn@gmail.com">
                                        info.cloudkitchen@gmail.com
                                    </a>
                                </div>
                            </div>

                            <div class="contact-info-item">
                                <div class="contact-icon">
                                    <i class="bi bi-clock-fill"></i>
                                </div>
                                <div>
                                    <h6>Working Hours</h6>
                                    <p>Monday - Sunday : 10:00 AM - 11:00 PM</p>
                                </div>
                            </div>

                            <div class="contact-social">
                                <a href="#"><i class="bi bi-facebook"></i></a>
                                <a href="https://www.instagram.com/vinitsonii"><i class="bi bi-instagram"></i></a>
                                <a href="#"><i class="bi bi-twitter-x"></i></a>
                                <a href="#"><i class="bi bi-youtube"></i></a>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </section>

    </ContentTemplate>
</asp:UpdatePanel>

    <script type="text/javascript">

        document.addEventListener('DOMContentLoaded', function () {
            const slides = document.querySelectorAll('.slide-img');
            let currentSlide = 0;
            setInterval(() => {
                slides[currentSlide].classList.remove('active');
                currentSlide = (currentSlide + 1) % slides.length;
                slides[currentSlide].classList.add('active');
            }, 3000);
        });

        document.addEventListener('DOMContentLoaded', function () {
            const searchBar = document.getElementById('searchBar');
            const suggestions = document.getElementById('suggestions');
            let dishes = [];

            fetch('Home.aspx/GetMenuItems', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({})
            })
            .then(r => r.json())
            .then(data => {
                dishes = data.d ? JSON.parse(data.d) : data;
            })
            .catch(err => console.error('Error fetching menu items:', err));

            searchBar.addEventListener('input', function () {
                const input = searchBar.value.toLowerCase();
                suggestions.innerHTML = '';
                if (input.length > 0) {
                    const filtered = dishes.filter(d => d.toLowerCase().includes(input));
                    filtered.forEach(dish => {
                        const p = document.createElement('p');
                        p.textContent = dish;
                        p.addEventListener('click', () => {
                            searchBar.value = dish;
                            suggestions.innerHTML = '';
                        });
                        suggestions.appendChild(p);
                    });
                    if (!filtered.length) suggestions.innerHTML = '<p>No matching dishes found.</p>';
                }
            });

            document.addEventListener('click', e => {
                if (!e.target.closest('.hero-search')) suggestions.innerHTML = '';
            });
        });

        function saveSearchValue() {
            document.getElementById("<%= hiddenSearch.ClientID %>").value =
                document.getElementById("searchBar").value;
        }

        document.addEventListener("DOMContentLoaded", function () {
            const messages = document.querySelectorAll(".message-item");
            const bar = document.getElementById("testimonialBar");
            let idx = 0;
            let timer;

            function show() {
                messages.forEach(m => m.classList.remove('active'));
                if (messages.length === 0) return;
                messages[idx].classList.add('active');
                bar.style.transition = 'none';
                bar.style.width = '0';
                requestAnimationFrame(() => {
                    requestAnimationFrame(() => {
                        bar.style.transition = 'width 4.5s linear';
                        bar.style.width = '100%';
                    });
                });
                idx = (idx + 1) % messages.length;
            }

            if (messages.length > 0) {
                show();
                timer = setInterval(show, 4500);

                const card = document.querySelector('.message-card');
                card.addEventListener('mouseenter', () => clearInterval(timer));
                card.addEventListener('mouseleave', () => {
                    show();
                    timer = setInterval(show, 4500);
                });
            }
        });

        let isScrolling = false;
        document.addEventListener('keydown', e => {
            if (e.key === 'ArrowDown' && !isScrolling) {
                isScrolling = true;
                smoothScroll(50, 300);
            }
        });
        document.addEventListener('keyup', e => {
            if (e.key === 'ArrowDown') isScrolling = false;
        });

        function smoothScroll(dist, dur) {
            let start = null;
            let pos = window.scrollY;
            function step(ts) {
                if (!start) start = ts;
                const pct = Math.min((ts - start) / dur, 2);
                window.scrollTo(0, pos + dist * pct);
                if (pct < 1 && isScrolling) requestAnimationFrame(step);
                else if (isScrolling) { start = null; pos = window.scrollY; requestAnimationFrame(step); }
            }
            requestAnimationFrame(step);
        }

    </script>

</asp:Content>
