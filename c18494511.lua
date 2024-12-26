--氷水帝エジル・ラーン
---@param c Card
function c18494511.initial_effect(c)
	aux.AddCodeList(c,7142724)
	--special summon (self)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18494511,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,18494511)
	e1:SetCost(c18494511.spcost)
	e1:SetTarget(c18494511.sptg)
	e1:SetOperation(c18494511.spop)
	c:RegisterEffect(e1)
	--change name
	aux.EnableChangeCode(c,7142724,LOCATION_MZONE,c18494511.codecon)
end
function c18494511.costfilter(c)
	local b1=c:IsSetCard(0x16c)
	local b2=c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_MONSTER)
	return (b1 or b2) and c:IsDiscardable()
end
function c18494511.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18494511.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c18494511.costfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c18494511.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c18494511.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,18494512,0x16c,TYPES_TOKEN_MONSTER,0,0,3,RACE_AQUA,ATTRIBUTE_WATER)
			and Duel.SelectYesNo(tp,aux.Stringid(18494511,1)) then
			Duel.BreakEffect()
			local token=Duel.CreateToken(tp,18494512)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetAbsoluteRange(tp,1,0)
			e1:SetTarget(c18494511.splimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			Duel.SpecialSummonComplete()
		end
	end
end
function c18494511.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER) and c:IsLocation(LOCATION_EXTRA)
end
function c18494511.codecon(e)
	return e:GetHandler():GetEquipCount()>0
end
