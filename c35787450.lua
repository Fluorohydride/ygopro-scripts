--エターナル・ドレッド
function c35787450.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c35787450.addtg)
	e1:SetOperation(c35787450.addc)
	c:RegisterEffect(e1)
end
function c35787450.check(tp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	return tc and tc:IsFaceup() and tc:IsCode(75041269) and tc:IsCanAddCounter(0x1b,2)
end
function c35787450.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c35787450.check(0) or c35787450.check(1) end
end
function c35787450.addc(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if tc and tc:IsFaceup() and tc:IsCode(75041269) then
		tc:AddCounter(0x1b,2)
	end
	tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
	if tc and tc:IsFaceup() and tc:IsCode(75041269) then
		tc:AddCounter(0x1b,2)
	end
end
