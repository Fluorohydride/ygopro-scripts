--ペンデュラム・シフト
function c19501924.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCountLimit(1,19501924+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c19501924.target)
	e1:SetOperation(c19501924.activate)
	e1:SetValue(c19501924.zones)
	c:RegisterEffect(e1)
end
function c19501924.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local ft=0
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if p0 then ft=ft+1 end
	if p1 then ft=ft+1 end
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	local st=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local b1=not b and ft>0
	local b2=b and ft==1 and st-ft>0
	local b3=b and ft==2
	if b1 or b3 then return zone end
	if b2 and p0 then zone=zone-0x1 end
	if b2 and p1 then zone=zone-0x10 end
	return zone
end
function c19501924.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c19501924.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ft=ft+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ft=ft+1 end
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	local st=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local b1=not b and ft>0
	local b2=b and ft==1 and st-ft>0
	local b3=b and ft==2
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c19501924.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19501924.cfilter,tp,LOCATION_MZONE,0,1,nil) and (b1 or b2 or b3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	Duel.SelectTarget(tp,c19501924.cfilter,tp,LOCATION_MZONE,0,1,ft,nil)
end
function c19501924.mfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c19501924.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ft=ft+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ft=ft+1 end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c19501924.mfilter,nil,e)
	if g:GetCount()>0 then
		if g:GetCount()<=ft then
			local tc=g:GetFirst()
			while tc do
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
				tc=g:GetNext()
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g:Select(tp,ft,ft,nil)
			local tc=sg:GetFirst()
			while tc do
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
				tc=sg:GetNext()
			end
			g:Sub(sg)
			Duel.SendtoGrave(g,REASON_RULE)
		end
	end
end
