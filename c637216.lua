--モンスターエクスプレス
function c637216.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(637216,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,637216)
	e1:SetTarget(c637216.tgtg)
	e1:SetOperation(c637216.tgop)
	c:RegisterEffect(e1)
end
function c637216.cfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c637216.tgfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetOriginalRace())
end
function c637216.tgfilter(c,race)
	return c:IsAbleToGrave() and c:GetOriginalRace()==race
end
function c637216.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c637216.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c637216.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c637216.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c637216.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local race=tc:GetOriginalRace()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c637216.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,race)
		if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetLabel(g:GetFirst():GetOriginalRace())
			e1:SetTargetRange(1,0)
			e1:SetTarget(c637216.splimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c637216.splimit(e,c)
	return not c:IsRace(e:GetLabel())
end
