# Newt 🦎

![Newt Logo](images/Newt.png)

> **Orchestrating Intelligent Linux Updates.**

Newt is an open-source platform designed to manage and deliver Over-the-Air (OTA) software updates to fleets of Linux devices. It uses the resilience of Elixir to ensure deployments.

## 🚀 Mission
Newt aims to solve the "last mile" problem of IoT and Edge Linux management by providing:
* **Reliable Delivery:** Updates are transactionally safe.
* **Device Intelligence:** Collects and visualizes real-time attributes (CPU, Disk, Custom Metrics) from every device.
* **Rule-Based Targeting:** Deploy packages to specific devices based on tags, geography, or hardware version.

## wd Architecture
The project is split into two main components:

### 1. The Terrarium (Server) *[In Progress]*
The command center built with **Elixir** and **Phoenix LiveView**. It handles:
* Device registration and authentication.
* Dashboard for monitoring fleet health.
* Deployment orchestration and rule management.

### 2. The Agent (Device) *[In Progress]*
A lightweight client running on the target Linux system. It is responsible for:
* Heartbeating status to the Terrarium.
* Pulling updates (Docker containers or binaries).
* Executing A/B partition swaps (if configured).

## 🛠️ Quick Start (Development)

We use **Docker** and **Make** to simplify the local development environment.

### Prerequisites
* Docker & Docker Compose
* Make

### Installation
1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/DanielLob-o/newt.git](https://github.com/DanielLob-o/newt.git)
    cd newt
    ```

2.  **Start the Terrarium:**
    This command spins up the Postgres database and the Phoenix server in a watched container.
    ```bash
    make start
    ```

3.  **Access the Dashboard:**
    Open your browser and navigate to:
    [http://localhost:4000](http://localhost:4000)

4.  **Stop the environment:**
    ```bash
    make stop
    ```

## 🏗️ Tech Stack
* **Language:** Elixir
* **Framework:** Phoenix LiveView
* **Database:** PostgreSQL
* **Infrastructure:** Docker Compose

## 📄 License
Newt is released under the [Apache 2.0 License](LICENSE).