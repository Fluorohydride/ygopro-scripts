--エターナル・ドレッド
---@param c Card
function c35787450.initial_effect(c)
	aux.AddCodeList(c,75041269)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c35787450.addtg)
	e1:SetOperation(c35787450.addc)
	c:RegisterEffect(e1)
end
function c35787450.filter(c)
	return c:IsFaceup() and c:IsCode(75041269) and c:IsCanAddCounter(0x1b,2)
end
function c35787450.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35787450.filter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) end
end
function c35787450.addc(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c35787450.filter,tp,LOCATION_FZONE,LOCATION_FZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1b,2)
		tc=g:GetNext()
	end
end
