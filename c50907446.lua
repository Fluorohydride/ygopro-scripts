--エルシャドール・アプカローネ
function c50907446.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c50907446.FShaddollCondition())
	e1:SetOperation(c50907446.FShaddollOperation())
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c50907446.splimit)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50907446,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,50907446)
	e3:SetTarget(c50907446.distg)
	e3:SetOperation(c50907446.disop)
	c:RegisterEffect(e3)
	--indes battle
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(50907446,1))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,50907447)
	e5:SetTarget(c50907446.thtg)
	e5:SetOperation(c50907446.thop)
	c:RegisterEffect(e5)
end
function c50907446.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c50907446.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c50907446.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
end
function c50907446.thfilter(c)
	return c:IsSetCard(0x9d) and c:IsAbleToHand()
end
function c50907446.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50907446.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end
function c50907446.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c50907446.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsLocation(LOCATION_HAND) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		end
	end
end
function c50907446.FShaddollFilter(c,fc)
	return c:IsFusionSetCard(0x9d) and c:IsCanBeFusionMaterial(fc)
end
function c50907446.FShaddollExFilter(c,fc)
	return c:IsFaceup() and c50907446.FShaddollFilter(c,fc)
end
function c50907446.FShaddollFilter1(c,g)
	return c:IsFusionSetCard(0x9d) and g:IsExists(c50907446.FShaddollFilter2,1,c) and not g:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute())
end
function c50907446.FShaddollFilter2(c)
	return c:IsFusionSetCard(0x9d)
end
function c50907446.FShaddollSpFilter1(c,fc,tp,mg,exg,chkf)
	return mg:IsExists(c50907446.FShaddollSpFilter2,1,c,fc,tp,c,chkf)
		or (exg and exg:IsExists(c50907446.FShaddollSpFilter2,1,c,fc,tp,c,chkf))
end
function c50907446.FShaddollSpFilter2(c,fc,tp,mc,chkf)
	local sg=Group.FromCards(c,mc)
	if sg:IsExists(aux.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
	if not aux.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,sg,fc) then return false end
	return ((c50907446.FShaddollFilter1(c,sg) and c50907446.FShaddollFilter2(mc))
		or (c50907446.FShaddollFilter1(mc,sg) and c50907446.FShaddollFilter2(c)))
		and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
end
function c50907446.FShaddollCondition()
	return  function(e,g,gc,chkf)
			if g==nil then return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
			local c=e:GetHandler()
			local mg=g:Filter(c50907446.FShaddollFilter,nil,c)
			local tp=e:GetHandlerPlayer()
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			local exg=nil
			if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
				exg=Duel.GetMatchingGroup(c50907446.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c)
			end
			if gc then
				if not mg:IsContains(gc) then return false end
				return c50907446.FShaddollSpFilter1(gc,c,tp,mg,exg,chkf)
			end
			return mg:IsExists(c50907446.FShaddollSpFilter1,1,nil,c,tp,mg,exg,chkf)
		end
end
function c50907446.FShaddollOperation()
	return  function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
			local c=e:GetHandler()
			local mg=eg:Filter(c50907446.FShaddollFilter,nil,c)
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			local exg=nil
			if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
				exg=Duel.GetMatchingGroup(c50907446.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c)
			end
			local g=nil
			if gc then
				g=Group.FromCards(gc)
				mg:RemoveCard(gc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				g=mg:FilterSelect(tp,c50907446.FShaddollSpFilter1,1,1,nil,c,tp,mg,exg,chkf)
				mg:Sub(g)
			end
			if exg and exg:IsExists(c50907446.FShaddollSpFilter2,1,nil,c,tp,g:GetFirst(),chkf)
				and (mg:GetCount()==0 or (exg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81788994,0)))) then
				fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=exg:FilterSelect(tp,c50907446.FShaddollSpFilter2,1,1,nil,c,tp,g:GetFirst(),chkf)
				g:Merge(sg)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=mg:FilterSelect(tp,c50907446.FShaddollSpFilter2,1,1,nil,c,tp,g:GetFirst(),chkf)
				g:Merge(sg)
			end
			Duel.SetFusionMaterial(g)
		end
end
