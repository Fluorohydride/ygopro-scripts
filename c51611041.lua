--模拘撮星人 エピゴネン
---@param c Card
function c51611041.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,51611041)
	e1:SetCost(c51611041.spcost)
	e1:SetTarget(c51611041.sptg)
	e1:SetOperation(c51611041.spop)
	c:RegisterEffect(e1)
end
function c51611041.costfilter(c,tp)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup() and Duel.GetMZoneCount(tp,c)>=2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,51611042,0,TYPES_TOKEN_MONSTER,0,0,1,c:GetOriginalRace(),c:GetOriginalAttribute())
end
function c51611041.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c51611041.costfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rc=Duel.SelectReleaseGroup(tp,c51611041.costfilter,1,1,nil,tp):GetFirst()
	e:SetLabel(rc:GetOriginalRace(),rc:GetOriginalAttribute())
	Duel.Release(rc,REASON_COST)
end
function c51611041.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsPlayerCanSpecialSummonCount(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c51611041.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local race,attr=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,51611042,0,TYPES_TOKEN_MONSTER,0,0,1,race,attr) then
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,51611042)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(race)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(attr)
		token:RegisterEffect(e2)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
