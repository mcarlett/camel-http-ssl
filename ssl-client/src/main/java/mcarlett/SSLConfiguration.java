package mcarlett;

import org.apache.camel.support.jsse.ClientAuthentication;
import org.apache.camel.support.jsse.FilterParameters;
import org.apache.camel.support.jsse.KeyManagersParameters;
import org.apache.camel.support.jsse.KeyStoreParameters;
import org.apache.camel.support.jsse.SSLContextClientParameters;
import org.apache.camel.support.jsse.SSLContextParameters;
import org.apache.camel.support.jsse.SSLContextServerParameters;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SSLConfiguration {

	@Bean("clientConfig")
	public SSLContextParameters sslContextParameters() {
		final SSLContextParameters sslContextParameters = new SSLContextParameters();

		final KeyStoreParameters ksp = new KeyStoreParameters();
		ksp.setResource("classpath:client.jks");
		ksp.setPassword("pass123");

		final KeyManagersParameters kmp = new KeyManagersParameters();
		kmp.setKeyStore(ksp);
		kmp.setKeyPassword("pass123");

		final FilterParameters filter = new FilterParameters();
		filter.getInclude().add(".*");

		final SSLContextClientParameters sccp = new SSLContextClientParameters();
		sccp.setCipherSuitesFilter(filter);

		sslContextParameters.setClientParameters(sccp);
		sslContextParameters.setKeyManagers(kmp);

		return sslContextParameters;
	}
}
