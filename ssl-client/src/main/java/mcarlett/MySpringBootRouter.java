package mcarlett;

import org.apache.camel.builder.RouteBuilder;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;

/**
 * A simple Camel route that triggers from a timer and calls a bean and prints to system out.
 * <p/>
 * Use <tt>@Component</tt> to make Camel auto detect this route when starting.
 */
@Component
public class MySpringBootRouter extends RouteBuilder {

    @Override
    public void configure() {
        rest()
                .get("ping")
                .produces(MediaType.TEXT_PLAIN_VALUE)
                .to("direct:call-ssl-server");

        from("direct:call-ssl-server")
                .to("https://localhost:8443/ping?bridgeEndpoint=true&sslContextParameters=#clientConfig");
    }

}
