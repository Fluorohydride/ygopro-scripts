--底なし落とし穴
function c69599136.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c69599136.target)
	e1:SetOperation(c69599136.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c69599136.filter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()~=tp
end
function c69599136.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c69599136.filter,1,nil,tp) end
	Duel.SetTargetCard(eg)
end
function c69599136.filter2(c,e,tp)
	return c:IsFaceup() and c:GetSummonPlayer()~=tp and c:IsRelateToEffect(e) 
end
function c69599136.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c69599136.filter2,nil,e,tp)
	if Duel.ChangePosition(g,POS_FACEDOWN_DEFENCE)~=0 then
		local og=Duel.GetOperatedGroup()
		local tc=og:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc=og:GetNext()
		end
	end
end
