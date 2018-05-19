--星遺物－『星槍』
function c46647144.initial_effect(c)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46647144,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,46647144)
	e1:SetCondition(c46647144.atkcon)
	e1:SetCost(c46647144.atkcost)
	e1:SetOperation(c46647144.atkop)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c46647144.atktg)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(46647144,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,46647145)
	e3:SetCondition(c46647144.tkcon)
	e3:SetTarget(c46647144.tktg)
	e3:SetOperation(c46647144.tkop)
	c:RegisterEffect(e3)
end
function c46647144.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	e:SetLabelObject(d)
	local g=Group.FromCards(a,d)
	return a and d and a:IsRelateToBattle() and d:IsRelateToBattle() and g:IsExists(Card.IsType,1,nil,TYPE_LINK)
end
function c46647144.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c46647144.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-3000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c46647144.atktg(e,c)
	return c:IsFaceup() and c:IsSetCard(0xfe) and c~=e:GetHandler()
end
function c46647144.cfilter(c,tp)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c46647144.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c46647144.cfilter,1,nil,tp)
end
function c46647144.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c46647144.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,46647145,0xfe,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,46647145,0xfe,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,1-tp) 
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local token1=Duel.CreateToken(tp,46647145)
	local token2=Duel.CreateToken(tp,46647145)
	Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	Duel.SpecialSummonStep(token2,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	Duel.SpecialSummonComplete()
end
