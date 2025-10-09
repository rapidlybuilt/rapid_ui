class LayoutDemoController < ApplicationController
  layout "rapid_ui/application", only: :show

  def search
    query = params[:q]&.strip&.downcase

    # Mock search data - in a real app this would by more dynamic
    search_data = [
      { title: "Dashboard Overview", description: "Main dashboard with key metrics", type: "page", url: "/dashboard" },
      { title: "User Management", description: "Manage users and permissions", type: "page", url: "/users" },
      { title: "Settings Configuration", description: "Application settings and preferences", type: "page", url: "/settings" },
      { title: "API Documentation", description: "Complete API reference guide", type: "documentation", url: "/api-docs" },
      { title: "Error Logs", description: "System error logs and debugging info", type: "logs", url: "/logs" },
      { title: "Performance Metrics", description: "Application performance statistics", type: "analytics", url: "/analytics" },
      { title: "Deployment History", description: "View and manage deployment records", type: "operations", url: "/deployments" },
      { title: "Audit Logs", description: "Security and access audit trails", type: "security", url: "/audit" },
      { title: "Team Management", description: "Manage teams and collaborators", type: "admin", url: "/teams" },
      { title: "Billing & Subscriptions", description: "Manage billing and subscription plans", type: "billing", url: "/billing" },
      { title: "Integration Settings", description: "Configure third-party integrations", type: "settings", url: "/integrations" },
      { title: "Reports Generator", description: "Create and schedule custom reports", type: "reports", url: "/reports" },
      { title: "Notification Center", description: "Manage system and user notifications", type: "notifications", url: "/notifications" },
      { title: "Backup & Recovery", description: "System backup and restore options", type: "maintenance", url: "/backup" },
      { title: "User Activity", description: "Monitor user actions and events", type: "monitoring", url: "/activity" },
      { title: "System Health", description: "Overall system status and health metrics", type: "status", url: "/health" }
    ]

    if query.present?
      @results = search_data.select do |item|
        item[:title].downcase.include?(query) ||
        item[:description].downcase.include?(query) ||
        item[:type].downcase.include?(query)
      end
    else
      @results = []
    end
  end
end
