package util;

import bean.dBConnection;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class AppShutDownListener implements ServletContextListener {
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        dBConnection.shutdown();
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Do nothing on startup.
    }
}
