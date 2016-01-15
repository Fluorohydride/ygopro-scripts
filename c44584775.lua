--ダメージ＝レプトル
function c44584775.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE)
	e1:SetCondition(c44584775.condition1)
	e1:SetTarget(c44584775.target1)
	e1:SetOperation(c44584775.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44584775,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c44584775.condition)
	e2:SetCost(c44584775.cost)
	e2:SetTarget(c44584775.target)
	e2:SetOperation(c44584775.activate)
	c:RegisterEffect(e2)
end
function c44584775.condition1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()~=PHASE_DAMAGE then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_BATTLE_DAMAGE,true)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return res and tep==tp and (a:IsRace(RACE_REPTILE) or (d and d:IsRace(RACE_REPTILE))) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c44584775.filter,tp,LOCATION_DECK,0,1,nil,e,tp,ev)
end
function c44584775.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetCurrentPhase()==PHASE_DAMAGE then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		e:GetHandler():RegisterFlagEffect(44584775,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	else
		e:SetCategory(0)
	end
end
function c44584775.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return ep==tp and (a:IsRace(RACE_REPTILE) or (d and d:IsRace(RACE_REPTILE)))
end
function c44584775.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(44584775)==0 end
	e:GetHandler():RegisterFlagEffect(44584775,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c44584775.filter(c,e,tp,dam)
	return c:IsAttackBelow(dam) and c:IsRace(RACE_REPTILE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c44584775.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c44584775.filter,tp,LOCATION_DECK,0,1,nil,e,tp,ev) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c44584775.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(44584775)==0 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c44584775.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ev)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
