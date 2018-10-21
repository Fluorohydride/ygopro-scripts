--Noble Knight Iyvanne
function c88923963.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88923963,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_EQUIP)
	e1:SetCountLimit(1,88923963)
	e1:SetCondition(c88923963.tkcon)
	e1:SetTarget(c88923963.tktg)
	e1:SetOperation(c88923963.tkop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c88923963.atkcon)
	e2:SetTarget(c88923963.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
end
function c88923963.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,0x207a)
end
function c88923963.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,88923964,0x107a,0x4011,1000,1000,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c88923963.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,88923964,0x107a,0x4011,1000,1000,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,88923964)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c88923963.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c88923963.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x107a)
end
function c88923963.atkcon(e)
	local c=e:GetHandler()
	local eg=c:GetEquipGroup()
	return #eg>0 and eg:IsExists(Card.IsSetCard,1,nil,0x207a)
end
function c88923963.atktg(e,c)
	return c:IsSetCard(0x107a) and c~=e:GetHandler()
end
