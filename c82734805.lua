--インフェルノイド・ティエラ
function c82734805.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c82734805.fscon)
	e1:SetOperation(c82734805.fsop)
	c:RegisterEffect(e1)
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82734805,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c82734805.con)
	e2:SetTarget(c82734805.tg)
	e2:SetOperation(c82734805.op)
	c:RegisterEffect(e2)
	--material check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c82734805.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
c82734805.material_count=2
c82734805.material={14799437,23440231}
function c82734805.valcheck(e,c)
	local ct=e:GetHandler():GetMaterial():GetClassCount(Card.GetCode)
	e:GetLabelObject():SetLabel(ct)
end
function c82734805.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c82734805.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	local con3,con5,con8,con10=nil
	if ct>=3 then
		con3=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,3,nil)
			and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,3,nil)
	end
	if ct>=5 then
		con5=Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.IsPlayerCanDiscardDeck(1-tp,3)
	end
	if ct>=8 then
		con8=Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,0,1,nil)
			and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_REMOVED,1,nil)
	end
	if ct>=10 then
		con10=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)>0
	end
	if chk==0 then return con3 or con5 or con8 or con10 end
	local cat=0
	if ct>=3 or ct>=8 then cat=cat+CATEGORY_TOGRAVE end
	if ct>=5 then cat=cat+CATEGORY_DECKDES end
	if ct>=10 then cat=cat+CATEGORY_HANDES end
	e:SetCategory(cat)
end
function c82734805.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct>=3 then
		local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,nil)
		local sg1=nil
		if g1:GetCount()>=3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			sg1=g1:Select(tp,3,3,nil)
		else sg1=g1 end
		local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
		local sg2=nil
		if g2:GetCount()>=3 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			sg2=g2:Select(1-tp,3,3,nil)
		else sg2=g2 end
		sg1:Merge(sg2)
		if sg1:GetCount()>0 then
			Duel.SendtoGrave(sg1,REASON_EFFECT)
		end
	end
	if ct>=5 then
		Duel.BreakEffect()
		Duel.DiscardDeck(tp,3,REASON_EFFECT)
		Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
	end
	if ct>=8 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_REMOVED,0,1,3,nil)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_REMOVED,0,1,3,nil)
		g1:Merge(g2)
		if g1:GetCount()>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT+REASON_RETURN)
		end
	end
	if ct>=10 then
		Duel.BreakEffect()
		local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
		Duel.SendtoGrave(g1,REASON_EFFECT)
	end
end
function c82734805.filter(c)
	return c:IsFusionSetCard(0xbb) and not c:IsHasEffect(6205579)
end
function c82734805.fcfilter1(c,code1,code2,g)
	return c:IsFusionCode(code1,code2) and g:IsExists(c82734805.filter,1,c)
end
function c82734805.fcfilter2(c,code,g,fc)
	return (c:IsFusionCode(code) or c:CheckFusionSubstitute(fc)) and g:IsExists(c82734805.filter,1,c)
end
function c82734805.fcfilter3(c,g,fc)
	return ((c:IsFusionCode(14799437) or c:CheckFusionSubstitute(fc)) and g:IsExists(Card.IsFusionCode,1,c,23440231))
		or ((c:IsFusionCode(23440231) or c:CheckFusionSubstitute(fc)) and g:IsExists(Card.IsFusionCode,1,c,14799437))
end
function c82734805.fcfilter4(c,code,fc)
	return c:IsFusionCode(code) or c:CheckFusionSubstitute(fc)
end
function c82734805.fcfilter7(c,chkf,fc)
	return aux.FConditionCheckF(c,chkf) and (c82734805.filter(c) or c:CheckFusionSubstitute(fc))
end
function c82734805.fscon(e,g,gc,chkf)
	if g==nil then return true end
	local c=e:GetHandler()
	local mg=g:Filter(Card.IsCanBeFusionMaterial,gc,c)
	if gc then
		if gc:CheckFusionSubstitute(c) then
			return mg:IsExists(c82734805.fcfilter1,1,nil,14799437,23440231,mg)
		elseif gc:IsFusionCode(14799437) then
			return mg:IsExists(c82734805.fcfilter2,1,nil,23440231,mg,c)
		elseif gc:IsFusionCode(23440231) then
			return mg:IsExists(c82734805.fcfilter2,1,nil,14799437,mg,c)
		elseif c82734805.filter(gc) then
			return mg:IsExists(c82734805.fcfilter3,1,nil,mg,c)
		else
			return false
		end
	end
	local b1=0 local b2=0 local b3=0 local bs=0
	local fs=false
	local tc=mg:GetFirst()
	while tc do
		if tc:CheckFusionSubstitute(c) then
			bs=1 if aux.FConditionCheckF(tc,chkf) then fs=true end
		elseif tc:IsFusionCode(14799437) then
			if b1==0 then b1=1 else b3=1 end if aux.FConditionCheckF(tc,chkf) then fs=true end
		elseif tc:IsFusionCode(23440231) then
			if b2==0 then b2=1 else b3=1 end if aux.FConditionCheckF(tc,chkf) then fs=true end
		elseif c82734805.filter(tc) then
			b3=1 if aux.FConditionCheckF(tc,chkf) then fs=true end
		end
		tc=mg:GetNext()
	end
	if chkf~=PLAYER_NONE then
		return fs and b1+b2+b3+bs>=3
	else
		return b1+b2+b3+bs>=3
	end
end
function c82734805.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local c=e:GetHandler()
	local mg=eg:Filter(Card.IsCanBeFusionMaterial,gc,c)
	local g1=Group.CreateGroup()
	if not gc and chkf~=PLAYER_NONE then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		gc=mg:FilterSelect(tp,c82734805.fcfilter7,1,1,nil,chkf,c):GetFirst()
		g1:AddCard(gc)
	end
	local ok=false
	if gc then
		if gc:CheckFusionSubstitute(c) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local sg=mg:FilterSelect(tp,c82734805.fcfilter1,1,1,nil,14799437,23440231,mg)
			g1:Merge(sg)
		elseif gc:IsFusionCode(14799437) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local sg=mg:FilterSelect(tp,c82734805.fcfilter2,1,1,nil,23440231,mg,c)
			g1:Merge(sg)
		elseif gc:IsFusionCode(23440231) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local sg=mg:FilterSelect(tp,c82734805.fcfilter2,1,1,nil,14799437,mg,c)
			g1:Merge(sg)
		elseif c82734805.filter(gc) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local sg=mg:FilterSelect(tp,c82734805.fcfilter3,1,1,nil,mg,c)
			g1:Merge(sg)
			local tc1=sg:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			if tc1:IsFusionCode(14799437) then
				local sg=mg:FilterSelect(tp,c82734805.fcfilter4,1,1,nil,23440231,c)
				g1:Merge(sg)
			elseif tc1:IsFusionCode(23440231) then
				local sg=mg:FilterSelect(tp,c82734805.fcfilter4,1,1,nil,14799437,c)
				g1:Merge(sg)
			else
				local sg=mg:FilterSelect(tp,aux.FConditionFilter21,1,1,nil,14799437,23440231)
				g1:Merge(sg)
			end
			ok=true
		end
	else
		local mg2=mg:Filter(aux.FConditionFilter22,nil,14799437,23440231,true,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg1=mg2:Select(tp,1,1,nil)
		local tc1=sg1:GetFirst()
		if not mg:IsExists(c82734805.filter,2,tc1) then
			mg2:Remove(c82734805.filter,nil)
		end
		if tc1:CheckFusionSubstitute(c) then
			mg2:Remove(Card.CheckFusionSubstitute,nil,c)
		else mg2:Remove(Card.IsFusionCode,nil,tc1:GetCode()) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg2=mg2:Select(tp,1,1,nil)
		g1:Merge(sg1)
		g1:Merge(sg2)
	end
	mg:Sub(g1)
	mg=mg:Filter(c82734805.filter,nil)
	if ok and (mg:GetCount()==0 or not Duel.SelectYesNo(tp,93)) then
		Duel.SetFusionMaterial(g1)
		return
	end
	if c:GetFlagEffect(31444249)~=0 then
		local dmg=mg:Filter(Card.IsLocation,nil,LOCATION_DECK)
		mg:Remove(Card.IsLocation,nil,LOCATION_DECK)
		if mg:GetCount()==0 or (dmg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(31444249,0))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local sg=dmg:Select(tp,1,6-g1:FilterCount(Card.IsLocation,nil,LOCATION_DECK),nil)
			g1:Merge(sg)
			if mg:GetCount()==0 or not Duel.SelectYesNo(tp,93) then
				Duel.SetFusionMaterial(g1)
				return
			end
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local sg=mg:Select(tp,1,99,nil)
	g1:Merge(sg)
	Duel.SetFusionMaterial(g1)
	return
end
