--希望皇オノマトピア
function c8512558.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8512558,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,8512558)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c8512558.sptg)
	e1:SetOperation(c8512558.spop)
	c:RegisterEffect(e1)
end
c8512558.combination2={}
c8512558.combination2[1]=aux.CreateChecks(Card.IsSetCard,{0x54,0x59})
c8512558.combination2[2]=aux.CreateChecks(Card.IsSetCard,{0x54,0x82})
c8512558.combination2[3]=aux.CreateChecks(Card.IsSetCard,{0x54,0x8f})
c8512558.combination2[4]=aux.CreateChecks(Card.IsSetCard,{0x59,0x82})
c8512558.combination2[5]=aux.CreateChecks(Card.IsSetCard,{0x59,0x8f})
c8512558.combination2[6]=aux.CreateChecks(Card.IsSetCard,{0x82,0x8f})
c8512558.combination3={}
c8512558.combination3[1]=aux.CreateChecks(Card.IsSetCard,{0x59,0x82,0x8f})
c8512558.combination3[2]=aux.CreateChecks(Card.IsSetCard,{0x54,0x82,0x8f})
c8512558.combination3[3]=aux.CreateChecks(Card.IsSetCard,{0x54,0x59,0x8f})
c8512558.combination3[4]=aux.CreateChecks(Card.IsSetCard,{0x54,0x59,0x82})
c8512558.combination4=aux.CreateChecks(Card.IsSetCard,{0x54,0x59,0x82,0x8f})
function c8512558.spfilter(c,e,tp)
	return c:IsSetCard(0x54,0x59,0x82,0x8f) and not c:IsCode(8512558) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c8512558.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c8512558.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c8512558.gcheck(g)
	if #g==1 then
		return true
	elseif #g==2 then
		return g:CheckSubGroupEach(c8512558.combination2[1])
			or g:CheckSubGroupEach(c8512558.combination2[2])
			or g:CheckSubGroupEach(c8512558.combination2[3])
			or g:CheckSubGroupEach(c8512558.combination2[4])
			or g:CheckSubGroupEach(c8512558.combination2[5])
			or g:CheckSubGroupEach(c8512558.combination2[6])
	elseif #g==3 then
		return g:CheckSubGroupEach(c8512558.combination3[1])
			or g:CheckSubGroupEach(c8512558.combination3[2])
			or g:CheckSubGroupEach(c8512558.combination3[3])
			or g:CheckSubGroupEach(c8512558.combination3[4])
	elseif #g==4 then
		return g:CheckSubGroupEach(c8512558.combination4)
	end
end
function c8512558.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c8512558.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 and #g>0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,c8512558.gcheck,false,1,math.min(4,ft))
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c8512558.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c8512558.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
