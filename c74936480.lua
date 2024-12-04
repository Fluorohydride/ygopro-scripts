--ダイノルフィア・ステルスベギア
function c74936480.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c74936480.ffilter,2,true)
	--cost change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_LPCOST_CHANGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c74936480.costchange)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,74936480)
	e2:SetCondition(c74936480.damcon)
	e2:SetTarget(c74936480.damtg)
	e2:SetOperation(c74936480.damop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,74936481)
	e3:SetCondition(c74936480.spcon)
	e3:SetTarget(c74936480.sptg)
	e3:SetOperation(c74936480.spop)
	c:RegisterEffect(e3)
end
function c74936480.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x173) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c74936480.costchange(e,re,rp,val)
	if Duel.GetLP(e:GetHandlerPlayer())<=2000 and re
		and (re:GetHandler():IsSetCard(0x173) and re:IsActiveType(TYPE_MONSTER)
			or re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_TRAP)) then
		return 0
	else return val end
end
function c74936480.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and re:IsActiveType(TYPE_MONSTER)
end
function c74936480.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local atk=rc:GetBaseAttack()
	if chk==0 then return atk>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c74936480.damop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local atk=rc:GetBaseAttack()
	Duel.Damage(1-tp,atk,REASON_EFFECT)
end
function c74936480.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c74936480.spfilter(c,e,tp)
	return c:IsSetCard(0x173) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c74936480.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c74936480.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c74936480.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c74936480.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
