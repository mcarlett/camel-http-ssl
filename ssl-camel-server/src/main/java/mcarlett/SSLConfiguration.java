package mcarlett;

import org.apache.camel.support.jsse.*;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SSLConfiguration {

	@Bean("serverConfig")
	public SSLContextParameters sslContextParameters() {
		final SSLContextParameters sslContextParameters = new SSLContextParameters();

		final KeyStoreParameters ksp = new KeyStoreParameters();
		ksp.setResource("classpath:server.jks");
		ksp.setPassword("pass123");
		ksp.setType("PKCS12");

		KeyManagersParameters kmp = new KeyManagersParameters();
		kmp.setKeyPassword("pass123");
		kmp.setKeyStore(ksp);

		sslContextParameters.setKeyManagers(kmp);

		return sslContextParameters;
	}
}
