--究極幻神 アルティミトル・ビシバールキン
---@param c Card
function c90884403.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c90884403.sprcon)
	e2:SetTarget(c90884403.sprtg)
	e2:SetOperation(c90884403.sprop)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c90884403.atkval)
	c:RegisterEffect(e4)
	--token
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(90884403,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMING_MAIN_END)
	e5:SetCountLimit(1)
	e5:SetCondition(c90884403.spcon)
	e5:SetTarget(c90884403.sptg)
	e5:SetOperation(c90884403.spop)
	c:RegisterEffect(e5)
end
function c90884403.sprfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(8) and c:IsAbleToGraveAsCost()
end
function c90884403.fselect(g,tp,sc)
	if not aux.gffcheck(g,Card.IsType,TYPE_TUNER,aux.NOT(Card.IsType),TYPE_TUNER)
		or Duel.GetLocationCountFromEx(tp,tp,g,sc)<=0 then return false end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	return tc1:IsLevel(tc2:GetLevel())
end
function c90884403.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c90884403.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c90884403.fselect,2,2,tp,c)
end
function c90884403.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c90884403.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c90884403.fselect,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c90884403.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c90884403.atkval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,LOCATION_MZONE)*1000
end
function c90884403.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c90884403.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local ct=math.min(ft1,ft2)
	if chk==0 then return ct>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,90884404,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,90884404,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct*2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct*2,0,0)
end
function c90884403.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local ct=math.min(ft1,ft2)
	if ct>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,90884404,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,90884404,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,1-tp) then
		for i=1,ct do
			local token=Duel.CreateToken(tp,90884404)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			token=Duel.CreateToken(tp,90884404)
			Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
		end
		Duel.SpecialSummonComplete()
	end
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
