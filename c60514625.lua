--エコール・ド・ゾーン
---@param c Card
function c60514625.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60514625,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,60514625)
	e1:SetCondition(c60514625.tkcon)
	e1:SetTarget(c60514625.tktg)
	e1:SetOperation(c60514625.tkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(c60514625.desop)
	c:RegisterEffect(e4)
end
function c60514625.tkcon(e,tp,eg,ep,ev,re,r,rp)
	if #eg~=1 then return false end
	local tc=eg:GetFirst()
	return tc:IsSummonPlayer(Duel.GetTurnPlayer())
end
function c60514625.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst()
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c60514625.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local p=tc:GetControler()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0
		and Duel.GetLocationCount(p,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(p,60514626,0,TYPES_TOKEN_MONSTER,-2,-2,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) then
		local atk=tc:GetPreviousAttackOnField()
		local def=tc:GetPreviousDefenseOnField()
		local token=Duel.CreateToken(tp,60514626)
		if Duel.SpecialSummonStep(token,0,p,p,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue(def)
			token:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e3)
		end
	end
	Duel.SpecialSummonComplete()
end
function c60514625.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,60514626)
	Duel.Destroy(g,REASON_EFFECT)
end
